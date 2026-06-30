# RM Turtle+ Simplified Standalone Architecture

**Status:** Accepted direction  
**Decision Date:** 2026-06-30

## Direction

RM Turtle+ shall remain simple and standalone.

The project shall not modify RadioMaster RF2 files, Betaflight widget files, radio firmware files, or any other radio system software.

## Accepted Implementation Boundary

The only active script file intended for radio installation is:

```text
/SCRIPTS/MIXES/RMTur.lua
```

## Design Goal

One standalone EdgeTX mixer script shall eventually:

- Read the pilot's existing arm request input.
- Read the pilot's Turtle switch input.
- Produce two mixer outputs.
- Apply simple fixed timing between sequence steps.

## Explicit Non-Goals

RM Turtle+ shall not:

- Edit `/SCRIPTS/RF2/background.lua`.
- Edit `/SCRIPTS/FUNCTIONS/rf2bg.lua`.
- Integrate into RF2 background tasks.
- Depend on Betaflight telemetry.
- Depend on the RadioMaster Betaflight widget.
- Add background Lua scripts.
- Modify radio firmware.

## Safety Approach

The pilot's existing native EdgeTX logical-switch setup remains the fallback and known-good configuration.

Any Lua version must be tested with props removed before being assigned to ARM or Turtle Mode AUX channels.

## Keep It Simple Rule

Every proposed feature must pass this test:

> Does it make automatic Turtle Mode safer or easier without increasing setup complexity?

If not, it is not part of the first release.
