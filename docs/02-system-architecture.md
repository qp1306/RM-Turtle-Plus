# RM Turtle+ System Architecture

**Version:** 0.1 draft  
**Status:** Draft  
**Project Owner:** Grant Lauga  
**Lead Software Architect:** OpenAI ChatGPT

## 1. Purpose

This document defines the first architecture for RM Turtle+.

The design goal is a small, deterministic EdgeTX mixer script that reads pilot intent and outputs ARM and TURTLE channel values using an explicit state machine.

## 2. Architecture Overview

```text
Pilot Inputs
    |
    v
Input Manager
    |
    v
State Machine <--> Timer Engine
    |
    v
Output Manager
    |
    v
ARM Output / TURTLE Output
```

## 3. Major Components

### 3.1 Input Manager

Responsible for reading script inputs and normalising them into boolean intent values.

Initial inputs:

- Arm request input
- Turtle switch input
- Optional throttle input

Normalised values:

- `armRequest`
- `turtleRequest`
- `flightRequest`
- `throttleLow` where supported

### 3.2 State Machine

Responsible for deciding which state RM Turtle+ is in and what transition should happen next.

The state machine shall be explicit and named. It shall not rely on unrelated overlapping mixer delays.

Initial states:

- `DISARMED`
- `FLIGHT_READY`
- `ENTER_DISARM`
- `ENTER_SET_TURTLE`
- `ENTER_REARM`
- `TURTLE_READY`
- `EXIT_DISARM`
- `EXIT_CLEAR_TURTLE`
- `EXIT_REARM`
- `ERROR_SAFE`

### 3.3 Timer Engine

Responsible for timing transitions between states.

The timer engine shall:

- Start timing when a timed state begins.
- Report elapsed time.
- Report when a configured delay has expired.
- Avoid magic numbers inside the state machine.

Initial timing constants:

- `DISARM_TO_MODE_DELAY_MS = 400`
- `MODE_TO_ARM_DELAY_MS = 500`

### 3.4 Output Manager

Responsible for turning state machine decisions into mixer script outputs.

Initial outputs:

- ARM output
- TURTLE output

Outputs shall be conservative when the external arm request is false.

### 3.5 Configuration

v0.1 shall use named constants in the Lua file.

Later versions may support:

- Config table
- Model-specific settings
- On-radio configuration

### 3.6 Diagnostics

v0.1 may expose minimal diagnostics through comments or debug values.

Later versions may support:

- Debug output channel
- Status page
- Voice prompts
- Haptic alerts

## 4. Data Flow

### Normal Flight

```text
armRequest = true
switch = flight
state = FLIGHT_READY
ARM output = ON
TURTLE output = OFF
```

### Enter Turtle

```text
switch changes to turtle
state = ENTER_DISARM
ARM output = OFF
TURTLE output = OFF

400 ms later:
state = ENTER_SET_TURTLE
ARM output = OFF
TURTLE output = ON

500 ms later:
state = TURTLE_READY
ARM output = ON
TURTLE output = ON
```

### Exit Turtle

```text
switch changes to flight
state = EXIT_DISARM
ARM output = OFF
TURTLE output = ON

400 ms later:
state = EXIT_CLEAR_TURTLE
ARM output = OFF
TURTLE output = OFF

500 ms later:
state = FLIGHT_READY
ARM output = ON
TURTLE output = OFF
```

## 5. Safety Behaviour

If `armRequest` becomes false at any time, ARM output shall immediately become OFF.

For v0.1, Turtle output behaviour after arm request removal shall be conservative and shall return OFF unless a future requirement defines a different recovery path.

## 6. EdgeTX Script Type

The target implementation is an EdgeTX mixer script loaded from:

```text
/SCRIPTS/MIXES/
```

The file name should be kept short for EdgeTX compatibility. The working script name may be:

```text
RMTur.lua
```

## 7. v0.1 Design Constraints

- Fixed timing values.
- No configuration UI.
- No voice prompts.
- No haptic feedback.
- No telemetry dependency.
- Props-off testing only.

## 8. Future Architecture Expansion

Future versions may add:

- Configuration interface.
- Debug output.
- Voice prompts.
- Haptic feedback.
- Test mode.
- Release packaging.
