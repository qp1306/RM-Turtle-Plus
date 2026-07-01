# RM Turtle+ Installation Manual

## 1. Safety first

Remove the propellers before testing.

RM Turtle+ changes ARM and Turtle Mode AUX outputs. Do not use it on a live aircraft until it has been checked in:

1. Radio channel monitor.
2. Betaflight Receiver tab.
3. Betaflight Modes tab.
4. Props-off bench test.

## 2. Logical switches

RM Turtle+ does not create logical switches for arming.

Create or keep your normal safe arming request. The current tested radio setup is:

```text
L01  Edge     SHdown     [0.6s:<]      SFdown     0.1s
L02  a<x      Thr        -99           ---
L03  AND      L01        L02           ---
L04  Sticky   L03        SFup          ---
L05  AND      L04        SGup          ---
```

Meaning:

```text
L01 = SH momentary arm trigger
L02 = throttle must be below -99
L03 = SH trigger AND throttle low
L04 = sticky armed request, reset by SFup
L05 = optional/legacy helper line from the current model
```

Use this as the RM Turtle+ script input:

```text
ArmReq = L04
```

Important: RM Turtle+ uses L04, not L05. L05 can stay on the model if you use it elsewhere, but it is not selected in the RM Turtle+ script.

## 3. Final SG switch layout

The confirmed working SG layout is:

```text
SGup     = ignored / reserved
SGmiddle = Turtle Mode
SGdown   = Flight
```

On the EdgeTX screen this appears as:

```text
SGup     = SG↑
SGmiddle = SG-
SGdown   = SG↓
```

## 4. Copy the Lua file

Copy:

```text
src/RMTur.lua
```

to the radio SD card as:

```text
/SCRIPTS/MIXES/RMTur.lua
```

## 5. Enable the mixer script

On the radio:

```text
Model Setup -> Mixer Scripts
```

Select an empty Lua slot, for example `LUA1`, and choose:

```text
RMTur
```

Set:

```text
ArmReq = L04
SG     = SG
DMode  = 4
DArm   = 9
```

Timing:

```text
DMode = 4 = 0.4 seconds from ARM low to Turtle mode change
DArm  = 9 = 0.9 seconds total from start to ARM high
```

## 6. Add mixer output channels

Recommended output channels:

```text
CH5 Source = 1-RMTur/ARM
CH6 Source = 1-RMTur/TURTLE
```

For both mixer lines:

```text
Weight    = 100%
Switch    = ---
Offset    = 0%
Curve     = Diff / 0
Multiplex = Replace
```

Important: do not put L04, SG, or any other switch in the mixer line switch field. The Lua script already reads those inputs internally.

## 7. Betaflight channel mapping

With CH5 and CH6:

```text
CH5 = AUX1
CH6 = AUX2
```

Recommended Betaflight Modes setup:

```text
ARM mode    = AUX1
TURTLE mode = AUX2
```

Remove or disable old ARM/Turtle mode ranges that are no longer used.

## 8. ELRS / CRSF channel setup

If using ELRS / CRSF, make sure the radio channel range is:

```text
CH1 -> CH16
```

On the tested setup, changing the ELRS packet rate to:

```text
250 Hz
```

allowed extra channels to appear correctly in Betaflight.

## 9. Radio channel monitor test

With props removed:

### Disarmed

```text
ARM    = low
TURTLE = low
```

### Armed, normal flight

Use the arming sequence so L04 becomes active.

Expected:

```text
ARM    = high
TURTLE = low
```

### Enter Turtle Mode

Move:

```text
SGdown -> SGmiddle
```

Expected sequence:

```text
ARM low,  TURTLE low
ARM low,  TURTLE high
ARM high, TURTLE high
```

### Exit Turtle Mode

Move:

```text
SGmiddle -> SGdown
```

Expected sequence:

```text
ARM low,  TURTLE high
ARM low,  TURTLE low
ARM high, TURTLE low
```

### Safety override

Turn off your normal arm request with SFup.

Expected immediately:

```text
ARM low
TURTLE low
```

## 10. Betaflight Receiver tab test

Open Betaflight Configurator:

```text
Receiver
```

Check that the chosen AUX channels move from low to high as expected.

Do not continue until the Receiver tab matches the radio channel monitor.

## 11. Betaflight Modes tab setup

Open:

```text
Modes
```

Set ARM to the RM Turtle+ ARM output AUX channel.

Set Flip Over After Crash / Turtle Mode to the RM Turtle+ TURTLE output AUX channel.

Verify the mode highlights match the expected sequence.

## 12. First bench test

Props removed.

Confirm:

- Normal arming works.
- Entering Turtle Mode disarms first.
- Turtle Mode activates after the delay.
- The quad re-arms into Turtle Mode.
- Exiting Turtle Mode disarms first.
- Turtle Mode turns off after the delay.
- The quad re-arms into normal flight mode.

## 13. Known tested setup

- Radio: RadioMaster TX16S MK3
- Radio firmware: EdgeTX RadioMaster pre-2.12 build
- Receiver protocol: CRSF / ELRS
- ELRS packet rate for full channel availability: 250 Hz
- Channel range: CH1 -> CH16
- Flight firmware: Betaflight 4.5.2
- Betaflight Configurator: 2025.12.2
