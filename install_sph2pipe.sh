#!/bin/bash

# sph2pipe installation script extracted from Kaldi's Makefile
# This script downloads and compiles sph2pipe v2.5

set -e  # Exit on error

# Configuration
SPH2PIPE_VERSION=2.5
WGET=${WGET:-wget}
CC=${CC:-gcc}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing sph2pipe v${SPH2PIPE_VERSION}...${NC}"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required tools
echo "Checking for required tools..."
if ! command_exists "$CC"; then
    echo -e "${RED}Error: $CC not found. Please install a C compiler.${NC}"
    exit 1
fi

if ! command_exists "$WGET"; then
    echo -e "${RED}Error: wget not found. Please install wget.${NC}"
    exit 1
fi

# Download sph2pipe
if [ ! -f "sph2pipe-${SPH2PIPE_VERSION}.tar.gz" ]; then
    echo "Downloading sph2pipe-${SPH2PIPE_VERSION}.tar.gz..."
    $WGET -nv -T 10 -t 3 -O sph2pipe-${SPH2PIPE_VERSION}.tar.gz \
        https://github.com/burrmill/sph2pipe/archive/${SPH2PIPE_VERSION}.tar.gz || {
        echo -e "${RED}Failed to download sph2pipe. Trying alternative source...${NC}"
        $WGET -nv -T 10 -t 3 -O sph2pipe-${SPH2PIPE_VERSION}.tar.gz \
            https://www.openslr.org/resources/3/sph2pipe_v${SPH2PIPE_VERSION}.tar.gz || {
            echo -e "${RED}Failed to download from all sources.${NC}"
            exit 1
        }
    }
else
    echo "Using existing sph2pipe-${SPH2PIPE_VERSION}.tar.gz"
fi

# Extract tarball
echo "Extracting sph2pipe..."
rm -rf sph2pipe_v${SPH2PIPE_VERSION} sph2pipe-${SPH2PIPE_VERSION}
tar -xzf sph2pipe-${SPH2PIPE_VERSION}.tar.gz

# Rename directory to match Kaldi convention
mv sph2pipe-${SPH2PIPE_VERSION} sph2pipe_v${SPH2PIPE_VERSION}

# Apply macOS workaround if needed
if [ "$(uname)" = "Darwin" ]; then
    echo "Applying macOS workaround..."
    sed -i '' -e "s/#define _XOPEN_SOURCE 500/#define _XOPEN_SOURCE 600/g" \
        sph2pipe_v${SPH2PIPE_VERSION}/sph2pipe.c
    sed -i '' -e "s/#define _XOPEN_SOURCE 500/#define _XOPEN_SOURCE 600/g" \
        sph2pipe_v${SPH2PIPE_VERSION}/file_headers.c
fi

# Compile sph2pipe
echo "Compiling sph2pipe..."
cd sph2pipe_v${SPH2PIPE_VERSION}
make CC="$CC" || {
    echo -e "${RED}Compilation failed.${NC}"
    exit 1
}
cd ..

# Create symbolic link
rm -f sph2pipe
ln -s sph2pipe_v${SPH2PIPE_VERSION} sph2pipe

echo -e "${GREEN}sph2pipe installation completed successfully!${NC}"
echo ""
echo "The sph2pipe binary is located at: $(pwd)/sph2pipe/sph2pipe"
echo ""
echo "To install system-wide, run:"
echo "  sudo cp $(pwd)/sph2pipe/sph2pipe /usr/local/bin/"
echo ""
echo "Or add to your PATH:"
echo "  export PATH=\"$(pwd)/sph2pipe:\$PATH\""
echo ""
echo "Test the installation with:"
echo "  ./sph2pipe/sph2pipe -h"
