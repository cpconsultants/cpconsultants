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
# Update paths in index.html to point to site/
# Handle both absolute URLs (https://cpconsultants.in/) and relative paths (/)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - update absolute URLs
    sed -i '' 's|href="https://cpconsultants.in/|href="https://cpconsultants.in/site/|g' index.html
    sed -i '' 's|src="https://cpconsultants.in/|src="https://cpconsultants.in/site/|g' index.html
    sed -i '' 's|action="https://cpconsultants.in/|action="https://cpconsultants.in/site/|g' index.html
    # Update relative paths (but not absolute external URLs)
    sed -i '' 's|href="/|href="/site/|g' index.html
    sed -i '' 's|src="/|src="/site/|g' index.html
    sed -i '' 's|action="/|action="/site/|g' index.html
    # Fix homepage link back to root
    sed -i '' 's|href="/site/"|href="/"|g' index.html
else
    # Linux - update absolute URLs
    sed -i 's|href="https://cpconsultants.in/|href="https://cpconsultants.in/site/|g' index.html
    sed -i 's|src="https://cpconsultants.in/|src="https://cpconsultants.in/site/|g' index.html
    sed -i 's|action="https://cpconsultants.in/|action="https://cpconsultants.in/site/|g' index.html
    # Update relative paths
    sed -i 's|href="/|href="/site/|g' index.html
    sed -i 's|src="/|src="/site/|g' index.html
    sed -i 's|action="/|action="/site/|g' index.html
    # Fix homepage link back to root
    sed -i 's|href="/site/"|href="/"|g' index.html
fi

echo "Deployment ready! Only index.html is in root, rest in site/ directory."

