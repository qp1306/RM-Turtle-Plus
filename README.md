# RM Turtle+

A simple standalone EdgeTX mixer script for automating Betaflight Turtle Mode / Flip Over After Crash.

RM Turtle+ keeps your existing safe arming logic and adds an automatic timed sequence for entering and exiting Turtle Mode.

## What it does

When armed and SG is moved from flight to Turtle Mode:

```text
ARM off -> wait -> TURTLE on -> wait -> ARM on
```

When SG is moved back to flight:

```text
ARM off -> wait -> TURTLE off -> wait -> ARM on
```

## Project direction

This project is intentionally simple.

- One installable Lua mixer script.
- No RF2 changes.
- No RadioMaster system file changes.
- No firmware changes.
- No Betaflight widget dependency.
- No background scripts.

Install target:

```text
/SCRIPTS/MIXES/RMTur.lua
```

## Tested workflow

```text
SG↑ = Ignored / reserved
SG- = Turtle Mode
SG↓ = Flight
```

Recommended script settings:

```text
ArmReq = L04
SG     = SG
DMode  = 4
DArm   = 9
```

Recommended output channels:

```text
CH5 = 1-RMTur/ARM    -> Betaflight AUX1
CH6 = 1-RMTur/TURTLE -> Betaflight AUX2
```

## Important ELRS / CRSF note

For extra AUX channels to reach Betaflight, use a packet rate that supports the required channel count. On the tested setup, changing ELRS packet rate to **250 Hz** allowed the additional channels to appear correctly in Betaflight.

Also confirm the radio channel range is set to:

```text
CH1 -> CH16
```

## Safety

Always test with props removed before using this on a real quad.

RM Turtle+ does not replace Betaflight arming checks, failsafe, or pilot safety discipline.

## Documentation

See:

```text
docs/INSTALLATION.md
```

for the full setup and test procedure.
