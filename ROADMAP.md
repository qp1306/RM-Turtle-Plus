# RM Turtle+ Roadmap

## Milestone 0: Foundation

- Create repository
- Establish project roles
- Add README
- Add changelog
- Add requirements documentation
- Add architecture documentation
- Add testing plan

## Milestone 1: Alpha Core

Goal: prove the core automatic Turtle Mode sequence as a Lua mixer script on a RadioMaster TX16S MK3 running EdgeTX.

Planned work:

- Mixer script skeleton
- Input mapping
- Output mapping
- State machine
- Timer engine
- Fixed timing values
- Bench-test procedure

## Milestone 2: Configurable Alpha

Goal: allow timing values and switch behaviour to be configured without rewriting the core logic.

Planned work:

- Config table
- Adjustable delays
- Installation guide
- Lumo18 example configuration

## Milestone 3: Beta

Goal: improve usability and diagnostics.

Planned work:

- Status output
- Debug mode
- Voice prompt support
- Haptic feedback support
- Improved safety checks

## Milestone 4: Release Candidate

Goal: prepare for public use.

Planned work:

- Full user manual
- Full test checklist
- Known limitations
- Release packaging

## Milestone 5: v1.0.0

Goal: first stable public release.

Release requires:

- Bench tested
- Radio channel monitor tested
- Betaflight receiver/modes tested
- Flight tested
- Documentation complete
