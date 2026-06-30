# ADR-0001: Preserve Existing Arm Logic

**Status:** Accepted  
**Date:** 2026-06-30  
**Project:** RM Turtle+

## Context

FPV pilots often already have mature arming workflows configured in EdgeTX. In the first target setup, the pilot uses a sticky arming sequence requiring throttle low and an SH switch action to reduce the chance of accidental arming.

RM Turtle+ needs to automate Betaflight Turtle Mode entry and exit, but replacing the existing arming logic would increase risk, installation complexity and pilot retraining.

## Decision

RM Turtle+ shall not replace the pilot's preferred arming workflow.

Instead, RM Turtle+ shall accept an external arm request input and use it as the pilot's permission to produce ARM output.

During Turtle entry and exit sequences, RM Turtle+ may temporarily override the ARM output to perform controlled disarm and re-arm timing. When not sequencing, the ARM output shall follow the external arm request.

## Consequences

### Positive

- Pilots keep their existing arming habits.
- The first target model keeps its proven SH/throttle-low sticky arm workflow.
- Installation is less disruptive.
- The project remains compatible with many different arming styles.

### Negative

- RM Turtle+ must clearly document how to connect the external arm request input.
- Incorrect user setup could cause confusing behaviour.
- Testing must verify interaction between the external arm request and the RM Turtle+ state machine.

## Related Requirements

- FR-001: Preserve Existing Arm Logic
- FR-004: No Arm Request Means No Arm Output
- SR-002: No Hidden Initial Arming
- SR-004: Pilot Override
