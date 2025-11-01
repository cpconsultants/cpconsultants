#!/bin/bash
# Deploy script for GitHub Pages - builds Hugo and copies to root

set -e

echo "Building Hugo site..."
hugo --minify

echo "Copying generated files to root..."
cp -r public/* .

echo "Deployment ready! Commit and push the root directory files."

