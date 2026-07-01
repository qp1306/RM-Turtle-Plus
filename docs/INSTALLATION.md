# RM Turtle+ Installation Manual

## 1. Safety first

Remove the propellers before testing.

RM Turtle+ changes ARM and Turtle Mode AUX outputs. Do not use it on a live aircraft until it has been checked in:

1. Radio channel monitor.
2. Betaflight Receiver tab.
3. Betaflight Modes tab.
4. Props-off bench test.

## 2. Important: RM Turtle+ does not create your arming logic

RM Turtle+ does **not** create logical switches for arming.

You must already have, or manually create, a safe arming request logical switch. In the tested setup this is:

```text
L04 = safe sticky arm request
```

RM Turtle+ uses that switch as its `ArmReq` input.

This is intentional. The script should not replace the pilot's preferred safety arming sequence.

## 3. Example arming logic used on the tested model

The tested model uses a throttle-low plus SH arming sequence to reduce accidental arming.

Example structure:

```text
L01 = SH arm trigger
L02 = Throttle low check
L03 = L01 AND L02
L04 = Sticky arm request
```

Use your existing working arming setup if you already have one. The only requirement is that the final arming request switch, for example `L04`, is ON when the pilot wants the quad armed and OFF when the pilot wants it disarmed.

Recommended tested setup:

```text
ArmReq = L04
```

## 4. What RM Turtle+ does

RM Turtle+ is one standalone EdgeTX mixer script.

It reads:

```text
ArmReq  = your existing safe arm request, for example L04
SG      = SG switch
```

It outputs:

```text
ARM
TURTLE
```

The tested switch workflow is:

```text
SG- = Flight
SG  = Turtle Mode
SG+ = ignored / reserved
```

## 5. Copy the Lua file

Copy the file:

```text
src/RMTur.lua
```

from the repository to the radio SD card as:

```text
/SCRIPTS/MIXES/RMTur.lua
```

## 6. Enable the mixer script

On the radio:

```text
Model Setup -> Mixer Scripts
```

Select an empty Lua slot, for example `LUA1`, and choose:

```text
RMTur
```

Set the script inputs:

```text
ArmReq = L04
SG     = SG
DMode  = 4
DArm   = 9
```

Timing meaning:

```text
DMode = 4 = 0.4 seconds from ARM low to Turtle mode change
DArm  = 9 = 0.9 seconds total from start to ARM high
```

## 7. Add mixer output channels

Choose two output channels that reach Betaflight. On the tested setup CH11 and CH12 were used.

Example:

```text
CH11 Source = 1-RMTur/ARM
CH12 Source = 1-RMTur/TURTLE
```

For both mixer lines:

```text
Weight = 100%
Switch = ---
Offset = 0%
Curve  = Diff / 0
```

Important: do not put `L04`, `SG`, or any other switch in the mixer line switch field. The Lua script already reads those inputs internally.

## 8. ELRS / CRSF channel setup

If using ELRS / CRSF, make sure the radio channel range is:

```text
CH1 -> CH16
```

On the tested setup, higher packet rates did not expose all required AUX channels in Betaflight. Changing the packet rate to:

```text
250 Hz
```

allowed the extra channels to appear correctly.

If CH11 and CH12 move on the radio but AUX7/AUX8 do not move in Betaflight, check packet rate and channel range first.

## 9. Betaflight channel mapping

Betaflight AUX mapping normally follows:

```text
CH5  = AUX1
CH6  = AUX2
CH7  = AUX3
CH8  = AUX4
CH9  = AUX5
CH10 = AUX6
CH11 = AUX7
CH12 = AUX8
```

If using CH11 and CH12:

```text
ARM mode    = AUX7
TURTLE mode = AUX8
```

Remove or disable old ARM/Turtle mode ranges that are no longer used.

## 10. Radio channel monitor test

With props removed:

### Disarmed

```text
ARM    = low
TURTLE = low
```

### Armed, normal flight

Use your normal arming sequence so `ArmReq` becomes active.

Expected:

```text
ARM    = high
TURTLE = low
```

### Enter Turtle Mode

Move:

```text
SG- -> SG
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
SG -> SG-
```

Expected sequence:

```text
ARM low,  TURTLE high
ARM low,  TURTLE low
ARM high, TURTLE low
```

### Safety override

Turn off your normal arm request.

Expected immediately:

```text
ARM low
TURTLE low
```

## 11. Betaflight Receiver tab test

Open Betaflight Configurator:

```text
Receiver
```

Check that the chosen AUX channels move from low to high as expected.

Do not continue until the Receiver tab matches the radio channel monitor.

## 12. Betaflight Modes tab setup

Open:

```text
Modes
```

Set ARM to the RM Turtle+ ARM output AUX channel.

Set Flip Over After Crash / Turtle Mode to the RM Turtle+ TURTLE output AUX channel.

Verify the mode highlights match the expected sequence.

## 13. First bench test

Props removed.

Confirm:

- Normal arming works.
- Entering Turtle Mode disarms first.
- Turtle Mode activates after the delay.
- The quad re-arms into Turtle Mode.
- Exiting Turtle Mode disarms first.
- Turtle Mode turns off after the delay.
- The quad re-arms into normal flight mode.

## 14. Known tested setup

- Radio: RadioMaster TX16S MK3
- Radio firmware: EdgeTX RadioMaster pre-2.12 build
- Receiver protocol: CRSF / ELRS
- ELRS packet rate for full channel availability: 250 Hz
- Channel range: CH1 -> CH16
- Flight firmware: Betaflight 4.5.2
- Betaflight Configurator: 2025.12.2
