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

echo "Copying index.html and page directories to root..."
cp public/index.html .

# Create page directories in root and copy their index.html files
mkdir -p about clients services enquiry contact
cp public/about/index.html about/index.html 2>/dev/null || true
cp public/clients/index.html clients/index.html 2>/dev/null || true
cp public/services/index.html services/index.html 2>/dev/null || true
cp public/enquiry/index.html enquiry/index.html 2>/dev/null || true
cp public/contact/index.html contact/index.html 2>/dev/null || true

echo "Updating paths in root pages to point to site/ for assets..."
# Update paths in root page directories to point to ../site/ for assets
find about clients services enquiry contact -name "index.html" -type f | while read htmlfile; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's|href=https://cpconsultants\.in/css/|href=../site/css/|g' "$htmlfile"
        sed -i '' 's|src=https://cpconsultants\.in/css/|src=../site/css/|g' "$htmlfile"
        sed -i '' 's|href=https://cpconsultants\.in/js/|href=../site/js/|g' "$htmlfile"
        sed -i '' 's|src=https://cpconsultants\.in/js/|src=../site/js/|g' "$htmlfile"
        sed -i '' 's|href=https://cpconsultants\.in/images/|href=../site/images/|g' "$htmlfile"
        sed -i '' 's|src=https://cpconsultants\.in/images/|src=../site/images/|g' "$htmlfile"
        sed -i '' 's|href="https://cpconsultants\.in/css/|href="../site/css/|g' "$htmlfile"
        sed -i '' 's|src="https://cpconsultants\.in/css/|src="../site/css/|g' "$htmlfile"
        sed -i '' 's|href="https://cpconsultants\.in/js/|href="../site/js/|g' "$htmlfile"
        sed -i '' 's|src="https://cpconsultants\.in/js/|src="../site/js/|g' "$htmlfile"
        sed -i '' 's|href="https://cpconsultants\.in/images/|href="../site/images/|g' "$htmlfile"
        sed -i '' 's|src="https://cpconsultants\.in/images/|src="../site/images/|g' "$htmlfile"
    else
        sed -i 's|href=https://cpconsultants\.in/css/|href=../site/css/|g' "$htmlfile"
        sed -i 's|src=https://cpconsultants\.in/css/|src=../site/css/|g' "$htmlfile"
        sed -i 's|href=https://cpconsultants\.in/js/|href=../site/js/|g' "$htmlfile"
        sed -i 's|src=https://cpconsultants\.in/js/|src=../site/js/|g' "$htmlfile"
        sed -i 's|href=https://cpconsultants\.in/images/|href=../site/images/|g' "$htmlfile"
        sed -i 's|src=https://cpconsultants\.in/images/|src=../site/images/|g' "$htmlfile"
        sed -i 's|href="https://cpconsultants\.in/css/|href="../site/css/|g' "$htmlfile"
        sed -i 's|src="https://cpconsultants\.in/css/|src="../site/css/|g' "$htmlfile"
        sed -i 's|href="https://cpconsultants\.in/js/|href="../site/js/|g' "$htmlfile"
        sed -i 's|src="https://cpconsultants\.in/js/|src="../site/js/|g' "$htmlfile"
        sed -i 's|href="https://cpconsultants\.in/images/|href="../site/images/|g' "$htmlfile"
        sed -i 's|src="https://cpconsultants\.in/images/|src="../site/images/|g' "$htmlfile"
    fi
done

echo "Updating paths in root index.html to point to site/..."
# Update paths in index.html to point to site/ using relative paths
# First, fix homepage links to stay as / before converting other URLs
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - first ensure homepage links stay as /
    sed -i '' 's|href="https://cpconsultants\.in/"|href="/"|g' index.html
    sed -i '' 's|href=https://cpconsultants\.in/">|href="/">|g' index.html
    # Convert absolute URLs to relative paths pointing to site/ (but not root /)
    sed -i '' 's|href=https://cpconsultants\.in/\([^> /][^> ]*\)|href=site/\1|g' index.html
    sed -i '' 's|src=https://cpconsultants\.in/\([^> ]*\)|src=site/\1|g' index.html
    sed -i '' 's|href="https://cpconsultants\.in/\([^"/][^"]*\)"|href="site/\1"|g' index.html
    sed -i '' 's|src="https://cpconsultants\.in/\([^"]*\)"|src="site/\1"|g' index.html
    # Don't modify external URLs (fonts.googleapis.com, etc.)
    sed -i '' 's|href=site/https://|href=https://|g' index.html
    sed -i '' 's|src=site/https://|src=https://|g' index.html
else
    # Linux - first ensure homepage links stay as /
    sed -i 's|href="https://cpconsultants\.in/"|href="/"|g' index.html
    sed -i 's|href=https://cpconsultants\.in/">|href="/">|g' index.html
    # Convert absolute URLs to relative paths pointing to site/ (but not root /)
    sed -i 's|href=https://cpconsultants\.in/\([^> /][^> ]*\)|href=site/\1|g' index.html
    sed -i 's|src=https://cpconsultants\.in/\([^> ]*\)|src=site/\1|g' index.html
    sed -i 's|href="https://cpconsultants\.in/\([^"/][^"]*\)"|href="site/\1"|g' index.html
    sed -i 's|src="https://cpconsultants\.in/\([^"]*\)"|src="site/\1"|g' index.html
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

