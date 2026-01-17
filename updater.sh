#!/usr/bin/env bash
# NixOS System Update Script
# This script handles flake updates and system rebuilds

set -e  # Exit on error

FLAKE_DIR="$HOME/.config/home-manager"
FLAKE_REF="$FLAKE_DIR#nixos"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}!${NC} ${1}"
}

# Parse command line arguments
UPDATE_FLAKE=true
BUILD_ONLY=false
TEST_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --no-update)
            UPDATE_FLAKE=false
            shift
            ;;
        --build-only)
            BUILD_ONLY=true
            shift
            ;;
        --test)
            TEST_MODE=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --no-update    Skip flake update, just rebuild"
            echo "  --build-only   Only build, don't activate (dry-run)"
            echo "  --test         Build and activate, but don't add to bootloader"
            echo "  -h, --help     Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║           NixOS System Updater                            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Step 1: Update flake inputs (unless --no-update is specified)
if [ "$UPDATE_FLAKE" = true ]; then
    print_step "Updating flake inputs..."
    cd "$FLAKE_DIR"
    
    if nix flake update; then
        print_success "Flake inputs updated"
        
        # Show what changed
        if [ -f flake.lock ]; then
            print_step "Checking for input changes..."
            git diff flake.lock | grep -E "^\+|^\-" | grep -v "lastModified" | grep -v "narHash" | head -20 || true
        fi
    else
        print_error "Failed to update flake inputs"
        exit 1
    fi
    echo ""
else
    print_warning "Skipping flake update (--no-update specified)"
    echo ""
fi

# Step 2: Check flake validity
print_step "Validating flake configuration..."
if nix flake check "$FLAKE_DIR" 2>&1 | grep -v "warning:"; then
    print_success "Flake configuration is valid"
else
    print_warning "Flake check completed with warnings (this might be okay)"
fi
echo ""

# Step 3: Build the system
if [ "$BUILD_ONLY" = true ]; then
    print_step "Building system (dry-run mode)..."
    if sudo nixos-rebuild dry-build --flake "$FLAKE_REF"; then
        print_success "Build completed successfully (not activated)"
    else
        print_error "Build failed"
        exit 1
    fi
elif [ "$TEST_MODE" = true ]; then
    print_step "Building and testing system (not added to bootloader)..."
    if sudo nixos-rebuild test --flake "$FLAKE_REF"; then
        print_success "System built and activated (test mode)"
        print_warning "This configuration won't survive a reboot!"
    else
        print_error "Build/test failed"
        exit 1
    fi
else
    print_step "Building and activating new system..."
    if sudo nixos-rebuild switch --flake "$FLAKE_REF"; then
        print_success "System rebuilt and activated successfully!"
    else
        print_error "Rebuild failed"
        exit 1
    fi
fi

echo ""
print_step "Current generation:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -5

echo ""
print_success "Update complete!"
echo ""
echo "Tips:"
echo "  • Roll back if needed: sudo nixos-rebuild switch --rollback"
echo "  • List generations: sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
echo "  • Clean old generations: sudo nix-collect-garbage -d"
echo ""
