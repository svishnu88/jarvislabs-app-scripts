#!/bin/bash

# Exit on error
set -e

echo "Starting ComfyUI server setup..."

# Check if uv is installed, if not install it
if ! command -v uv &> /dev/null; then
    echo "Installing uv package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source "$HOME/.local/bin/env"
fi

# Check if the directory already exists
if [ ! -d "ComfyUI" ]; then
    echo "Cloning ComfyUI repository..."
    git clone https://github.com/comfyanonymous/ComfyUI.git
else
    echo "ComfyUI directory already exists"
fi

# Navigate to the ComfyUI directory
cd ComfyUI

# Create virtual environment
echo "Setting up virtual environment..."
uv venv

# Use the Python interpreter from the virtual environment directly
VENV_PYTHON="$PWD/.venv/bin/python"

# Install requirements using uv
echo "Installing requirements..."
uv pip install -r requirements.txt

# Install ComfyUI-Manager if not already present
echo "Setting up ComfyUI-Manager..."
cd custom_nodes
if [ ! -d "ComfyUI-Manager" ]; then
    echo "Cloning ComfyUI-Manager repository..."
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git
    cd ComfyUI-Manager
    uv pip install -r requirements.txt
else
    echo "ComfyUI-Manager already exists"
    cd ComfyUI-Manager
    uv pip install -r requirements.txt
fi
cd ../..

# Launch the server using the venv Python
echo "Launching ComfyUI server..."
"$VENV_PYTHON" main.py --port 6006 --listen 0.0.0.0