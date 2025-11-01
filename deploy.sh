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
# Update paths in index.html to point to site/ using relative paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - convert absolute URLs to relative paths pointing to site/
    sed -i '' 's|href=https://cpconsultants\.in/\([^> ]*\)|href=site/\1|g' index.html
    sed -i '' 's|src=https://cpconsultants\.in/\([^> ]*\)|src=site/\1|g' index.html
    sed -i '' 's|href="https://cpconsultants\.in/\([^"]*\)"|href="site/\1"|g' index.html
    sed -i '' 's|src="https://cpconsultants\.in/\([^"]*\)"|src="site/\1"|g' index.html
    # Fix homepage link back to root
    sed -i '' 's|href="site/"|href="/"|g' index.html
    sed -i '' 's|href=site/">|href="/">|g' index.html
    # Don't modify external URLs (fonts.googleapis.com, etc.)
    sed -i '' 's|href=site/https://|href=https://|g' index.html
    sed -i '' 's|src=site/https://|src=https://|g' index.html
else
    # Linux - convert absolute URLs to relative paths pointing to site/
    sed -i 's|href=https://cpconsultants\.in/\([^> ]*\)|href=site/\1|g' index.html
    sed -i 's|src=https://cpconsultants\.in/\([^> ]*\)|src=site/\1|g' index.html
    sed -i 's|href="https://cpconsultants\.in/\([^"]*\)"|href="site/\1"|g' index.html
    sed -i 's|src="https://cpconsultants\.in/\([^"]*\)"|src="site/\1"|g' index.html
    # Fix homepage link back to root
    sed -i 's|href="site/"|href="/"|g' index.html
    sed -i 's|href=site/">|href="/">|g' index.html
    # Don't modify external URLs
    sed -i 's|href=site/https://|href=https://|g' index.html
    sed -i 's|src=site/https://|src=https://|g' index.html
fi

echo "Updating paths in all HTML files in site/ to use relative paths..."
# For files in subdirectories, use relative paths like ../css/main.css
find site -name "*.html" -type f | while read htmlfile; do
    # Calculate depth (number of slashes after site/)
    depth=$(echo "$htmlfile" | sed 's|site/||' | tr -cd '/' | wc -c)
    # Create relative path prefix based on depth
    if [ $depth -gt 0 ]; then
        relprefix=$(printf '../%.0s' $(seq 1 $depth))
    else
        relprefix=""
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - update paths in subdirectory HTML files
        # For CSS, JS, images - use relative path
        sed -i '' "s|href=https://cpconsultants\.in/css/|href=${relprefix}css/|g" "$htmlfile"
        sed -i '' "s|src=https://cpconsultants\.in/css/|src=${relprefix}css/|g" "$htmlfile"
        sed -i '' "s|href=https://cpconsultants\.in/js/|href=${relprefix}js/|g" "$htmlfile"
        sed -i '' "s|src=https://cpconsultants\.in/js/|src=${relprefix}js/|g" "$htmlfile"
        sed -i '' "s|href=https://cpconsultants\.in/images/|href=${relprefix}images/|g" "$htmlfile"
        sed -i '' "s|src=https://cpconsultants\.in/images/|src=${relprefix}images/|g" "$htmlfile"
        sed -i '' "s|href=\"https://cpconsultants\.in/css/|href=\"${relprefix}css/|g" "$htmlfile"
        sed -i '' "s|src=\"https://cpconsultants\.in/css/|src=\"${relprefix}css/|g" "$htmlfile"
        sed -i '' "s|href=\"https://cpconsultants\.in/js/|href=\"${relprefix}js/|g" "$htmlfile"
        sed -i '' "s|src=\"https://cpconsultants\.in/js/|src=\"${relprefix}js/|g" "$htmlfile"
        sed -i '' "s|href=\"https://cpconsultants\.in/images/|href=\"${relprefix}images/|g" "$htmlfile"
        sed -i '' "s|src=\"https://cpconsultants\.in/images/|src=\"${relprefix}images/|g" "$htmlfile"
        # For page links - keep pointing to site/ directory
        sed -i '' 's|href=https://cpconsultants\.in/\([^> ]*\)|href=/site/\1|g' "$htmlfile"
        sed -i '' 's|href="https://cpconsultants\.in/\([^"]*\)"|href="/site/\1"|g' "$htmlfile"
    else
        # Linux - same updates
        sed -i "s|href=https://cpconsultants\.in/css/|href=${relprefix}css/|g" "$htmlfile"
        sed -i "s|src=https://cpconsultants\.in/css/|src=${relprefix}css/|g" "$htmlfile"
        sed -i "s|href=https://cpconsultants\.in/js/|href=${relprefix}js/|g" "$htmlfile"
        sed -i "s|src=https://cpconsultants\.in/js/|src=${relprefix}js/|g" "$htmlfile"
        sed -i "s|href=https://cpconsultants\.in/images/|href=${relprefix}images/|g" "$htmlfile"
        sed -i "s|src=https://cpconsultants\.in/images/|src=${relprefix}images/|g" "$htmlfile"
        sed -i "s|href=\"https://cpconsultants\.in/css/|href=\"${relprefix}css/|g" "$htmlfile"
        sed -i "s|src=\"https://cpconsultants\.in/css/|src=\"${relprefix}css/|g" "$htmlfile"
        sed -i "s|href=\"https://cpconsultants\.in/js/|href=\"${relprefix}js/|g" "$htmlfile"
        sed -i "s|src=\"https://cpconsultants\.in/js/|src=\"${relprefix}js/|g" "$htmlfile"
        sed -i "s|href=\"https://cpconsultants\.in/images/|href=\"${relprefix}images/|g" "$htmlfile"
        sed -i "s|src=\"https://cpconsultants\.in/images/|src=\"${relprefix}images/|g" "$htmlfile"
        sed -i 's|href=https://cpconsultants\.in/\([^> ]*\)|href=/site/\1|g' "$htmlfile"
        sed -i 's|href="https://cpconsultants\.in/\([^"]*\)"|href="/site/\1"|g' "$htmlfile"
    fi
done

echo "Deployment ready! Only index.html is in root, rest in site/ directory."

