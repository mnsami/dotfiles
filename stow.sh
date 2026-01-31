#!/usr/bin/env bash
# Stow-based dotfiles management
# Usage: ./stow.sh [install|uninstall|restow]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

install_ai_rules() {
    echo "  Setting up ai-rules..."

    # Create ~/.config if it doesn't exist
    mkdir -p "$HOME/.config"

    # Remove existing symlink or directory
    if [ -L "$HOME/.config/ai-rulez" ]; then
        rm "$HOME/.config/ai-rulez"
    elif [ -d "$HOME/.config/ai-rulez" ]; then
        print_warning "~/.config/ai-rulez exists and is not a symlink. Backing up..."
        mv "$HOME/.config/ai-rulez" "$HOME/.config/ai-rulez.backup.$(date +%s)"
    fi

    # Create symlink
    ln -s "$DOTFILES_DIR/ai-rules" "$HOME/.config/ai-rulez"
    print_status "ai-rules → ~/.config/ai-rulez"
}

uninstall_ai_rules() {
    echo "  Removing ai-rules..."
    if [ -L "$HOME/.config/ai-rulez" ]; then
        rm "$HOME/.config/ai-rulez"
        print_status "ai-rules symlink removed"
    else
        print_warning "~/.config/ai-rulez is not a symlink, skipping"
    fi
}

install_packages() {
    check_stow
    echo "Installing dotfiles packages..."

    # Special handling for ai-rules (symlink to ~/.config/ai-rulez)
    if [ -d "$DOTFILES_DIR/ai-rules" ]; then
        install_ai_rules
    fi

    # Add more stow packages here if needed
    # Example: stow -v -d "$DOTFILES_DIR" -t "$HOME" "some-package"

    print_status "All packages installed!"
}

uninstall_packages() {
    check_stow
    echo "Uninstalling dotfiles packages..."

    # Special handling for ai-rules
    uninstall_ai_rules

    print_status "All packages uninstalled!"
}

restow_packages() {
    echo "Restowing dotfiles packages..."
    uninstall_packages
    install_packages
}

show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install   - Create symlinks for all packages (default)"
    echo "  uninstall - Remove all symlinks"
    echo "  restow    - Recreate all symlinks (useful after adding new files)"
    echo ""
    echo "Packages managed:"
    echo "  ai-rules → ~/.config/ai-rulez"
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
