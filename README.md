# sph2pipe Installation Script

A reliable installation script for sph2pipe - the SPHERE file format converter from LDC (Linguistic Data Consortium). This script provides a working installation method when other sources fail on modern systems.

## Why This Installation Script?

Installing sph2pipe from common sources often fails on modern systems:

 - OpenSLR (https://openslr.org/3): Build errors on recent Linux/macOS versions
 - robd003's fork (https://github.com/robd003/sph2pipe): Compilation issues with modern compilers
 - LDC official tools (https://www.ldc.upenn.edu/language-resources/tools/sphere-conversion-tools): Outdated build system, fails on both Linux and macOS

Our installation script extracts the working configuration from Kaldi's build system, which has been battle-tested across various platforms and includes necessary patches for modern systems.

## What is sph2pipe?

sph2pipe is a tool that converts SPHERE format audio files to other formats (WAV, RAW, etc.). It's essential for working with many speech corpora from LDC, including:

 - Fisher English/Spanish Corpus
 - Switchboard
 - CallHome
 - And many other LDC speech datasets

## Installation

```bash
# Make the script executable
chmod +x install_sph2pipe.sh

# Run the installation
./install_sph2pipe.sh

# Or install system-wide
sudo cp sph2pipe/sph2pipe /usr/local/bin/
```

## Usage

After installation, sph2pipe can be used to convert individual audio files:

```bash
# Convert SPH to WAV
sph2pipe input.sph output.wav
```

## Requirements

 - C compiler (gcc/clang)
 - wget
 - Bash shell

## Tested On

 - Ubuntu 20.04/22.04
 - macOS 12+ (Intel & Apple Silicon)
