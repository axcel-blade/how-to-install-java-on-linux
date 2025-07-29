#!/bin/bash

# Java Installation Script using SDKMAN
# This script installs SDKMAN and the latest Java version on Linux

set -e  # Exit on any error

echo "🚀 Starting Java installation with SDKMAN..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Linux
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    print_error "This script is designed for Linux systems only."
    exit 1
fi

# Check for required dependencies
print_status "Checking system dependencies..."
dependencies=("curl" "zip" "unzip")
missing_deps=()

for dep in "${dependencies[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        missing_deps+=("$dep")
    fi
done

# Install missing dependencies
if [ ${#missing_deps[@]} -gt 0 ]; then
    print_warning "Missing dependencies: ${missing_deps[*]}"
    print_status "Attempting to install missing dependencies..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y "${missing_deps[@]}"
    elif command -v yum &> /dev/null; then
        sudo yum install -y "${missing_deps[@]}"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y "${missing_deps[@]}"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm "${missing_deps[@]}"
    else
        print_error "Unable to install dependencies automatically. Please install: ${missing_deps[*]}"
        exit 1
    fi
fi

# Check if SDKMAN is already installed
if [ -d "$HOME/.sdkman" ]; then
    print_warning "SDKMAN is already installed. Updating..."
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk update
else
    print_status "Installing SDKMAN..."
    curl -s "https://get.sdkman.io" | bash
    
    # Source SDKMAN
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Verify SDKMAN installation
if ! command -v sdk &> /dev/null; then
    print_error "SDKMAN installation failed or not properly sourced."
    print_status "Please run: source ~/.bashrc or restart your terminal"
    exit 1
fi

print_success "SDKMAN is ready!"

# List available Java versions and install the latest
print_status "Fetching available Java versions..."
sdk list java | head -20

print_status "Installing the latest Java version..."
# Install the latest LTS version (usually the default)
sdk install java

# Set it as default
sdk default java

# Verify installation
print_status "Verifying Java installation..."
java_version=$(java -version 2>&1 | head -n 1)
javac_version=$(javac -version 2>&1)

if [[ $? -eq 0 ]]; then
    print_success "Java installation completed successfully!"
    echo -e "${GREEN}Java Runtime: ${NC}$java_version"
    echo -e "${GREEN}Java Compiler: ${NC}$javac_version"
    echo -e "${GREEN}JAVA_HOME: ${NC}$JAVA_HOME"
else
    print_error "Java installation verification failed."
    exit 1
fi

# Add SDKMAN initialization to shell profile if not already present
shell_profile=""
if [ -f "$HOME/.bashrc" ] && ! grep -q "sdkman-init.sh" "$HOME/.bashrc"; then
    shell_profile="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ] && ! grep -q "sdkman-init.sh" "$HOME/.zshrc"; then
    shell_profile="$HOME/.zshrc"
fi

if [ -n "$shell_profile" ]; then
    print_status "Adding SDKMAN initialization to $shell_profile..."
    echo "" >> "$shell_profile"
    echo "# SDKMAN" >> "$shell_profile"
    echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> "$shell_profile"
    echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> "$shell_profile"
    print_success "SDKMAN initialization added to $shell_profile"
fi

print_success "🎉 Installation complete!"
echo ""
echo "📝 Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "2. Verify installation: java -version"
echo "3. Use 'sdk list java' to see all available Java versions"
echo "4. Use 'sdk install java <version>' to install specific versions"
echo "5. Use 'sdk use java <version>' to switch between versions"
echo ""
echo "Happy coding! ☕"