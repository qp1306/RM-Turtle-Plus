# Changelog

All notable changes to RM Turtle+ will be documented in this file.

## [1.0.3] - 2026-06-30

### Changed

- Confirmed final SG switch layout:
  - `SG↑` = ignored / reserved
  - `SG-` = Turtle Mode
  - `SG↓` = Flight
- Updated recommended script input back to `ArmReq = L04`.
- Updated recommended output channels to CH5 and CH6:
  - CH5 / AUX1 = ARM
  - CH6 / AUX2 = TURTLE
- Updated installation manual to remove the incorrect L05 recommendation.

## [1.0.0] - 2026-06-30

### Added

- Standalone EdgeTX mixer script: `src/RMTur.lua`.
- Two script outputs: `ARM` and `TURTLE`.
- Support for existing safe arming logic via `ArmReq` input.
- Configurable timing inputs:
  - `DMode` default `4` = 0.4 seconds
  - `DArm` default `9` = 0.9 seconds total
- Full mixer-scale output for RadioMaster TX16S / EdgeTX.
- Installation and test manual.

### Changed

- Project simplified to one standalone mixer script.
- Removed RF2/background-script integration direction from the active project scope.

### Tested

- Script loads on RadioMaster TX16S MK3.
- Outputs move correctly in the radio channel monitor.
- CRSF channel range set to CH1-CH16.
- ELRS packet rate changed to 250 Hz so additional AUX channels reach Betaflight.

### Safety

- Props-off testing required before live use.
