#!/usr/bin/env bash
# Stow-based dotfiles management
# Usage: ./stow.sh [install|uninstall|restow]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Packages to manage with stow
# Each directory with a leading dot becomes a stow package
PACKAGES=(
    "ai-rules"  # AI rules for Claude Code, Cursor, etc.
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

check_stow() {
    if ! command -v stow &> /dev/null; then
        print_error "GNU Stow is not installed."
        echo "Install it with:"
        echo "  macOS: brew install stow"
        echo "  Ubuntu: sudo apt install stow"
        exit 1
    fi
}

install_packages() {
    check_stow
    echo "Installing dotfiles packages..."

    for package in "${PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            echo "  Stowing $package..."
            stow -v -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -v "^LINK" || true
            print_status "$package installed"
        else
            print_warning "Package $package not found, skipping"
        fi
    done

    print_status "All packages installed!"
}

uninstall_packages() {
    check_stow
    echo "Uninstalling dotfiles packages..."

    for package in "${PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            echo "  Unstowing $package..."
            stow -v -D -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -v "^UNLINK" || true
            print_status "$package uninstalled"
        fi
    done

    print_status "All packages uninstalled!"
}

restow_packages() {
    check_stow
    echo "Restowing dotfiles packages..."

    for package in "${PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            echo "  Restowing $package..."
            stow -v -R -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1 | grep -v "^LINK\|^UNLINK" || true
            print_status "$package restowed"
        fi
    done

    print_status "All packages restowed!"
}

show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install   - Create symlinks for all packages (default)"
    echo "  uninstall - Remove all symlinks"
    echo "  restow    - Recreate all symlinks (useful after adding new files)"
    echo ""
    echo "Packages managed: ${PACKAGES[*]}"
}

# Main
case "${1:-install}" in
    install)
        install_packages
        ;;
    uninstall)
        uninstall_packages
        ;;
    restow)
        restow_packages
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        show_usage
        exit 1
        ;;
esac
