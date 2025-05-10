#!/bin/bash

# 确保脚本在出错时退出
set -e

echo "Building Docker image for Sileo repo generation..."
docker build -t sileo-repo-builder .

echo "Running repo.sh inside Docker container..."
docker run --rm -v "$(pwd):/repo" sileo-repo-builder
gpg -abs -u 767D46A4709E4297AEDD4F0783BBBE5ADBD940CB -o Release.gpg Release
echo "Docker execution completed. Check the generated files in the current directory."
