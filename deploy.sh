#!/bin/bash
# Deploy script for GitHub Pages - builds Hugo and keeps only index.html in root

set -e

echo "Building Hugo site..."
hugo --minify

echo "Moving site files to site/ directory..."
rm -rf site
mkdir -p site
# Move everything except index.html to site/
find public -mindepth 1 -maxdepth 1 ! -name index.html -exec mv {} site/ \;

echo "Copying only index.html to root..."
cp public/index.html .

echo "Updating paths in root index.html to point to site/..."
# Update relative paths in index.html to point to site/
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' 's|href="/|href="/site/|g' index.html
    sed -i '' 's|src="/|src="/site/|g' index.html
    sed -i '' 's|action="/|action="/site/|g' index.html
else
    # Linux
    sed -i 's|href="/|href="/site/|g' index.html
    sed -i 's|src="/|src="/site/|g' index.html
    sed -i 's|action="/|action="/site/|g' index.html
fi

echo "Deployment ready! Only index.html is in root, rest in site/ directory."

