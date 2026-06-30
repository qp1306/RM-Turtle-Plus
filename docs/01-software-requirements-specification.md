# RM Turtle+ Software Requirements Specification

**Version:** 0.1 draft  
**Status:** Draft  
**Project Owner:** Grant Lauga  
**Lead Software Architect:** OpenAI ChatGPT

## 1. Purpose

RM Turtle+ is intended to provide an automatic, predictable and configurable Turtle Mode workflow for EdgeTX radios controlling Betaflight aircraft.

The first target radio is the RadioMaster TX16S MK3 running EdgeTX pre-2.12 RadioMaster build. The first target aircraft is the OXBOT Lumo18 running Betaflight.

## 2. Scope

RM Turtle+ shall automate the sequence required to enter and exit Betaflight Flip Over After Crash mode using a single pilot switch while preserving the pilot's preferred arming workflow.

The project shall not replace Betaflight safety logic, arming checks, receiver failsafe behaviour, or flight controller safety protections.

## 3. Definitions

- **ARM:** The RC channel assigned to Betaflight ARM mode.
- **TURTLE:** The RC channel assigned to Betaflight Flip Over After Crash mode.
- **Sticky Arm:** Existing pilot arming request logic, such as SH flick plus throttle low.
- **Flight position:** Normal switch position where Turtle Mode is off.
- **Turtle position:** Switch position where the automatic Turtle sequence is requested.
- **Sequence:** A timed set of output changes: disarm, mode change, re-arm.

## 4. Functional Requirements

### FR-001: Preserve Existing Arm Logic

RM Turtle+ shall accept an external arm request input rather than replacing the pilot's existing arming workflow.

### FR-002: Automatic Turtle Entry

When the aircraft is armed by pilot request and the Turtle switch is moved from Flight to Turtle, RM Turtle+ shall:

1. Set ARM output off.
2. Wait the configured disarm-to-mode delay.
3. Set TURTLE output on.
4. Wait the configured mode-to-arm delay.
5. Set ARM output on.

### FR-003: Automatic Turtle Exit

When the aircraft is in Turtle state and the Turtle switch is moved from Turtle to Flight, RM Turtle+ shall:

1. Set ARM output off.
2. Wait the configured disarm-to-mode delay.
3. Set TURTLE output off.
4. Wait the configured mode-to-arm delay.
5. Set ARM output on.

### FR-004: No Arm Request Means No Arm Output

If the external arm request is not active, RM Turtle+ shall keep ARM output off regardless of Turtle switch state.

### FR-005: Deterministic State Machine

RM Turtle+ shall implement its sequencing through an explicit state machine rather than unrelated overlapping delays.

### FR-006: Configurable Timing

Timing values shall be stored as named configuration values.

Initial defaults:

- Disarm-to-mode delay: 0.40 seconds
- Mode-to-arm delay: 0.50 seconds
- Total arm return time: approximately 0.90 seconds after sequence start

### FR-007: Mixer Script Output

The initial implementation shall operate as an EdgeTX mixer script with two outputs:

- ARM output
- TURTLE output

## 5. Safety Requirements

### SR-001: Props-Off Testing

All alpha versions shall be marked as props-off bench-test only until explicitly promoted.

### SR-002: No Hidden Initial Arming

RM Turtle+ shall not initiate first arm unless the pilot's external arm request is already active.

### SR-003: Fail Safe Output

If the script cannot determine a valid state, outputs should fail to a conservative state:

- ARM off
- TURTLE off unless specifically already in a controlled Turtle sequence

### SR-004: Pilot Override

If the external arm request is removed, RM Turtle+ shall immediately remove ARM output.

## 6. Non-Functional Requirements

### NFR-001: EdgeTX Compatibility

The initial target is RadioMaster TX16S MK3 with EdgeTX pre-2.12 RadioMaster build.

### NFR-002: Maintainability

The source code shall be commented and structured so future contributors can understand the state machine and timing behaviour.

### NFR-003: Documentation

Every release shall include usage notes, known limitations and test status.

## 7. Out of Scope for v0.1

- Voice prompts
- Haptic feedback
- On-radio configuration UI
- Telemetry-based crash detection
- Automatic channel detection
- Public flight-ready release

## 8. Acceptance Criteria for v0.1 Alpha

v0.1 alpha is accepted when:

1. The script appears in the TX16S mixer script list.
2. The script exposes ARM and TURTLE outputs.
3. Channel monitor confirms the enter sequence timing.
4. Channel monitor confirms the exit sequence timing.
5. Betaflight Receiver and Modes tabs confirm correct AUX behaviour.
6. Props-off bench test confirms motors reverse only when Turtle Mode is active and armed.
