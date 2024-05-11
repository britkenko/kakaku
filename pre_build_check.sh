#!/bin/bash

# Check if the ComfyUI directory exists
if [ -d "/app/ComfyUI" ]; then
    echo "ComfyUI directory exists."
    # Check if the package.json file exists in the ComfyUI directory
    if [ -f "/app/ComfyUI/package.json" ]; then
        echo "package.json found."
    else
        echo "package.json is missing in ComfyUI directory."
        exit 1
    fi
else
    echo "ComfyUI directory is missing."
    exit 1
fi
