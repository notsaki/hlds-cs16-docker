## Basic Information

- The dockerfile in the root directory is the base image.
- The AMX Mod X dockerfile requires the base image to be built first named as `tsaki/hlds-cs16`.
- The modified dockerfile includes requires the AmxModX image to be built as `tsaki/hlds-cs16-amxmodx` the following extra modifications:
  - ReHLDS
  - ReAPI
  - Reunion
  - ReGame DLL
  - Voice Transcoder
  - ReAuthCheck
  - ReChecker
  - WHBlocker

## Build the base image

- `cd base && docker build -t tsaki/hlds-cs16 .`

## Build the AMX Mod X image

- `cd base && docker build -t tsaki/hlds-cs16 .`.
- `cd ../amxmodx && docker build -t tsaki/hlds-cs16-amxmodx .`.

## Build the modified image

- `cd base && docker build -t tsaki/hlds-cs16 .`.
- `cd ../amxmodx && docker build -t tsaki/hlds-cs16-amxmodx .`.
- `cd ../modified && docker build -t tsaki/hlds-cs16-modified .`.