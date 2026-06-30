# RM Turtle+ Roadmap

## Current focus

RM Turtle+ is now focused on one simple standalone EdgeTX mixer script:

```text
/SCRIPTS/MIXES/RMTur.lua
```

No RF2 integration, no background scripts, no firmware changes.

## Completed

- Standalone mixer script loads on RadioMaster TX16S MK3.
- Script reads existing arm request input.
- Script reads SG switch.
- Script outputs ARM and TURTLE.
- Full output scale confirmed on the radio.
- ELRS / CRSF channel-range issue identified: packet rate changed to 250 Hz for full channel availability.
- Installation manual added.

## Next

- Final props-off Betaflight Modes test.
- Add screenshots to documentation.
- Create GitHub release package.

## Future ideas

Only after v1.0 is stable:

- Optional different switch layouts.
- Optional adjustable default timing presets.
- Extra examples for other radios or models.
