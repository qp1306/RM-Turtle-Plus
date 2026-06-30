# ADR-0002: Use an Explicit State Machine

**Status:** Accepted  
**Date:** 2026-06-30  
**Project:** RM Turtle+

## Context

The first working proof of concept used native EdgeTX logical switches and mix delays. It proved the required behaviour, but timing was difficult to reason about because multiple delays could overlap.

Betaflight Turtle Mode requires a specific sequence:

1. Disarm.
2. Change Turtle Mode state.
3. Re-arm.

The order and timing are critical. If re-arm occurs too soon, Betaflight may arm in the wrong mode or fail to reverse motors correctly.

## Decision

RM Turtle+ shall implement Turtle entry and exit using an explicit named state machine.

Each state shall define:

- Its purpose.
- Its output values.
- Its transition condition.
- Its timing requirement, where applicable.

The state machine shall be easier to inspect and test than a collection of unrelated delays.

## Consequences

### Positive

- Behaviour is deterministic and easier to test.
- Timing can be tuned in one place.
- Debugging becomes easier because the current state has a meaningful name.
- Future diagnostics can show the active state to the pilot.

### Negative

- The implementation is more complex than simple logical switches.
- The script must manage state correctly across repeated EdgeTX mixer-script calls.
- Care is required to ensure safe outputs if the script starts, stops or resets.

## Related Requirements

- FR-002: Automatic Turtle Entry
- FR-003: Automatic Turtle Exit
- FR-005: Deterministic State Machine
- FR-006: Configurable Timing
