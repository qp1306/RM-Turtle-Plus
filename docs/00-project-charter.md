# RM Turtle+ Project Charter

**Version:** 0.1 draft  
**Status:** Accepted for project foundation  
**Project Owner:** Grant Lauga  
**Lead Software Architect:** OpenAI ChatGPT

## 1. Mission

RM Turtle+ exists to make Betaflight Turtle Mode safer, simpler and more reliable without changing how pilots already arm and fly their aircraft.

## 2. Project Vision

RM Turtle+ is an open-source, safety-first automatic Turtle Mode controller for EdgeTX and Betaflight. It provides a deterministic state-machine workflow for entering and exiting Flip Over After Crash mode using a single pilot switch while preserving each pilot's preferred arming logic.

## 3. Primary Users

- FPV pilots using EdgeTX radios.
- Betaflight pilots who use Flip Over After Crash mode.
- RadioMaster TX16S users who want a repeatable Turtle Mode workflow.
- Developers who want to extend or audit the project.

## 4. First Target Platform

- Radio: RadioMaster TX16S MK3.
- Firmware: EdgeTX pre-2.12 RadioMaster build.
- Aircraft: OXBOT Lumo18.
- Flight firmware: Betaflight.

## 5. Scope

RM Turtle+ shall automate the RC output sequence required to enter and exit Betaflight Flip Over After Crash mode.

The first implementation shall focus on:

- ARM output sequencing.
- TURTLE output sequencing.
- Explicit state machine.
- Fixed timing defaults.
- Props-off validation.

## 6. Out of Scope

The project shall not replace:

- Betaflight arming checks.
- Flight controller failsafe logic.
- Receiver failsafe logic.
- Pilot safety discipline.
- Manual bench testing.

The project shall not be considered flight-ready until a tested release explicitly states that status.

## 7. Project Roles

### Project Owner

Grant Lauga is responsible for:

- Product direction.
- Real-world requirements.
- Hardware testing.
- Flight validation.
- Release approval.

### Lead Software Architect

OpenAI ChatGPT is responsible for:

- Software architecture.
- Requirements drafting.
- Code generation.
- Documentation generation.
- Test planning.
- Design review.

## 8. Core Principles

### Safety First

No feature is accepted if it makes aircraft behaviour less predictable.

### Deterministic Behaviour

For a given input sequence and timing configuration, the outputs shall be predictable and repeatable.

### Preserve Pilot Workflow

RM Turtle+ shall enhance existing arming workflows rather than replacing them.

### Documentation First

Major features shall have requirements and design notes before production code is written.

### Test Before Release

Every release shall identify its test status and known limitations.

## 9. Success Criteria for v1.0

RM Turtle+ v1.0 is successful when:

1. It can be installed by a normal EdgeTX user from GitHub release assets.
2. It exposes clear ARM and TURTLE outputs through an EdgeTX mixer script.
3. It reliably enters Turtle Mode using the configured switch sequence.
4. It reliably exits Turtle Mode and returns to normal flight output.
5. It is documented well enough for another pilot to install and test safely.
6. It has been bench tested and flight tested on the target platform.

## 10. Release Safety Notice

All alpha versions are experimental and must be tested with props removed. No alpha version shall be described as flight-ready.
