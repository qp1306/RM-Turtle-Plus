# RM Turtle+ State Machine Specification

**Version:** 0.1 draft  
**Status:** Draft  
**Project Owner:** Grant Lauga  
**Lead Software Architect:** OpenAI ChatGPT

## 1. Purpose

This document defines the RM Turtle+ v0.1 state machine.

The state machine is the core of RM Turtle+. It controls the ordered sequence used to enter and exit Betaflight Flip Over After Crash mode.

## 2. Design Goals

The state machine shall be:

- Explicit.
- Deterministic.
- Easy to debug.
- Easy to test.
- Safe on arm-request removal.
- Independent of overlapping mixer delays.

## 3. Inputs

| Input | Name | Meaning |
|---|---|---|
| External arm request | `armRequest` | Pilot's existing arming logic is active. |
| Turtle switch request | `turtleRequest` | Pilot requests Turtle Mode. |
| Flight switch request | `flightRequest` | Pilot requests normal flight mode. |
| Timer expired | `timerExpired` | Active timed state delay has completed. |

## 4. Outputs

| Output | Name | Meaning |
|---|---|---|
| ARM | `armOutput` | RC output assigned to Betaflight ARM mode. |
| TURTLE | `turtleOutput` | RC output assigned to Betaflight Flip Over After Crash mode. |

## 5. Timing Constants

Initial v0.1 defaults:

| Constant | Value | Purpose |
|---|---:|---|
| `DISARM_TO_MODE_DELAY_MS` | 400 ms | Time between ARM off and changing Turtle Mode. |
| `MODE_TO_ARM_DELAY_MS` | 500 ms | Time between changing Turtle Mode and ARM on. |

## 6. State List

| State | Purpose |
|---|---|
| `DISARMED` | No external arm request. Outputs are safe/off. |
| `FLIGHT_READY` | Normal armed flight output. ARM on, TURTLE off. |
| `ENTER_DISARM` | Start entering Turtle. ARM off, TURTLE still off. |
| `ENTER_SET_TURTLE` | Turtle mode is now on, ARM still off. |
| `ENTER_REARM` | Re-arm into Turtle Mode. |
| `TURTLE_READY` | Turtle Mode active and armed. |
| `EXIT_DISARM` | Start exiting Turtle. ARM off, TURTLE still on. |
| `EXIT_CLEAR_TURTLE` | Turtle mode is now off, ARM still off. |
| `EXIT_REARM` | Re-arm into normal flight. |
| `ERROR_SAFE` | Conservative fallback state. |

## 7. State Output Table

| State | ARM Output | TURTLE Output |
|---|---|---|
| `DISARMED` | OFF | OFF |
| `FLIGHT_READY` | ON | OFF |
| `ENTER_DISARM` | OFF | OFF |
| `ENTER_SET_TURTLE` | OFF | ON |
| `ENTER_REARM` | ON | ON |
| `TURTLE_READY` | ON | ON |
| `EXIT_DISARM` | OFF | ON |
| `EXIT_CLEAR_TURTLE` | OFF | OFF |
| `EXIT_REARM` | ON | OFF |
| `ERROR_SAFE` | OFF | OFF |

## 8. State Transitions

### 8.1 Startup

On script start:

- If `armRequest` is false, enter `DISARMED`.
- If `armRequest` is true and `turtleRequest` is false, enter `FLIGHT_READY`.
- If `armRequest` is true and `turtleRequest` is true, v0.1 shall not auto-start in Turtle Ready. It shall enter `ENTER_DISARM` so the full sequence is performed.

### 8.2 Disarmed to Flight Ready

`DISARMED` -> `FLIGHT_READY` when:

- `armRequest == true`
- `turtleRequest == false`

### 8.3 Flight Ready to Turtle Entry

`FLIGHT_READY` -> `ENTER_DISARM` when:

- `armRequest == true`
- `turtleRequest == true`

On entering `ENTER_DISARM`:

- Start timer for `DISARM_TO_MODE_DELAY_MS`.

### 8.4 Enter Disarm to Enter Set Turtle

`ENTER_DISARM` -> `ENTER_SET_TURTLE` when:

- Timer expired.
- `armRequest == true`.
- `turtleRequest == true`.

On entering `ENTER_SET_TURTLE`:

- Start timer for `MODE_TO_ARM_DELAY_MS`.

### 8.5 Enter Set Turtle to Turtle Ready

`ENTER_SET_TURTLE` -> `ENTER_REARM` when:

- Timer expired.
- `armRequest == true`.
- `turtleRequest == true`.

`ENTER_REARM` -> `TURTLE_READY` immediately after one update cycle.

### 8.6 Turtle Ready to Turtle Exit

`TURTLE_READY` -> `EXIT_DISARM` when:

- `armRequest == true`
- `turtleRequest == false`

On entering `EXIT_DISARM`:

- Start timer for `DISARM_TO_MODE_DELAY_MS`.

### 8.7 Exit Disarm to Exit Clear Turtle

`EXIT_DISARM` -> `EXIT_CLEAR_TURTLE` when:

- Timer expired.
- `armRequest == true`.
- `turtleRequest == false`.

On entering `EXIT_CLEAR_TURTLE`:

- Start timer for `MODE_TO_ARM_DELAY_MS`.

### 8.8 Exit Clear Turtle to Flight Ready

`EXIT_CLEAR_TURTLE` -> `EXIT_REARM` when:

- Timer expired.
- `armRequest == true`.
- `turtleRequest == false`.

`EXIT_REARM` -> `FLIGHT_READY` immediately after one update cycle.

## 9. Arm Request Removal

If `armRequest` becomes false in any state, the state machine shall transition to `DISARMED` immediately.

This is a safety rule and has priority over all timed transitions.

## 10. Rapid Switch Changes

v0.1 conservative behaviour:

- If the pilot changes the Turtle switch during an entry or exit sequence, the state machine shall follow the latest requested end state after returning to a safe disarmed phase.
- The implementation shall not skip the disarm-to-mode delay.
- The implementation shall not jump directly from Turtle Mode armed to Flight Mode armed without first passing through a disarmed state.

## 11. Error Safe State

`ERROR_SAFE` exists for invalid or unexpected conditions.

When in `ERROR_SAFE`:

- ARM output = OFF
- TURTLE output = OFF

Recovery from `ERROR_SAFE` shall require `armRequest == false`, which returns the system to `DISARMED`.

## 12. High-Level Diagram

```text
          +-----------+
          | DISARMED  |
          +-----+-----+
                |
                | armRequest true, turtle false
                v
        +---------------+
        | FLIGHT_READY  |
        +-------+-------+
                |
                | turtleRequest true
                v
        +---------------+
        | ENTER_DISARM  |
        +-------+-------+
                |
                | 400 ms
                v
     +--------------------+
     | ENTER_SET_TURTLE   |
     +---------+----------+
               |
               | 500 ms
               v
        +---------------+
        | ENTER_REARM   |
        +-------+-------+
                |
                v
        +---------------+
        | TURTLE_READY  |
        +-------+-------+
                |
                | turtleRequest false
                v
        +---------------+
        | EXIT_DISARM   |
        +-------+-------+
                |
                | 400 ms
                v
     +--------------------+
     | EXIT_CLEAR_TURTLE  |
     +---------+----------+
               |
               | 500 ms
               v
        +---------------+
        | EXIT_REARM    |
        +-------+-------+
                |
                v
        +---------------+
        | FLIGHT_READY  |
        +---------------+
```

## 13. v0.1 Acceptance Tests

The state machine is acceptable for v0.1 when:

1. It starts in a safe state when arm request is false.
2. It enters `FLIGHT_READY` only when arm request is true and Turtle request is false.
3. It executes the full Turtle entry sequence in order.
4. It executes the full Turtle exit sequence in order.
5. It removes ARM output immediately when arm request is removed.
6. It never changes Turtle output and ARM output at the same time during entry or exit.
