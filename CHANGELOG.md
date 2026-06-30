# Changelog

All notable changes to RM Turtle+ will be documented in this file.

## [1.0.0] - 2026-06-30

### Added

- Standalone EdgeTX mixer script: `src/RMTur.lua`.
- Two script outputs: `ARM` and `TURTLE`.
- Support for existing safe arming logic via `ArmReq` input.
- Tested SG workflow:
  - `SG-` = Flight
  - `SG` = Turtle Mode
  - `SG+` = ignored / reserved
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
