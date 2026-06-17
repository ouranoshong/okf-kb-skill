#!/bin/bash
# OKF Knowledge Base Skill Installer
# Usage: bash install.sh [target]
# Targets: omp (oh-my-pi), adk (adk-rust), jcode (jcode), local (current dir)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/kb"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

usage() {
    echo -e "${GREEN}OKF Knowledge Base Skill Installer${NC}"
    echo ""
    echo "Usage: bash install.sh [target]"
    echo ""
    echo "Targets:"
    echo "  omp     oh-my-pi    → ~/.omp/skills/kb/"
    echo "  adk     adk-rust    → .skills/kb/"
    echo "  jcode   jcode       → .jcode/skills/kb/"
    echo "  local   current dir → ./kb/"
    echo ""
    echo "If no target specified, will auto-detect or prompt."
}

detect_target() {
    # Auto-detect based on directory structure
    if [ -d ".jcode" ]; then
        echo "jcode"
    elif [ -d ".skills" ]; then
        echo "adk"
    elif [ -d ".agent" ] || [ -f ".agents.yaml" ] || [ -d ".oh-my-pi" ]; then
        echo "omp"
    else
        echo ""
    fi
}

get_target_path() {
    local target="$1"
    case "$target" in
        omp|oh-my-pi)
            echo "$HOME/.omp/skills/kb"
            ;;
        adk|adk-rust)
            echo ".skills/kb"
            ;;
        jcode)
            echo ".jcode/skills/kb"
            ;;
        local)
            echo "./kb"
            ;;
        *)
            echo ""
            ;;
    esac
}

install_skill() {
    local target_path="$1"

    if [ ! -d "$SKILL_DIR" ]; then
        echo -e "${RED}Error: kb/ directory not found in $SCRIPT_DIR${NC}"
        exit 1
    fi

    # Create target directory
    mkdir -p "$(dirname "$target_path")"

    # Copy skill files
    if [ -d "$target_path" ]; then
        echo -e "${YELLOW}Target exists: $target_path${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Aborted."
            exit 0
        fi
        rm -rf "$target_path"
    fi

    cp -r "$SKILL_DIR" "$target_path"
    echo -e "${GREEN}✓ Installed kb skill to: $target_path${NC}"
}

# Main
TARGET="${1:-}"

if [ "$TARGET" = "-h" ] || [ "$TARGET" = "--help" ]; then
    usage
    exit 0
fi

# Auto-detect if no target specified
if [ -z "$TARGET" ]; then
    TARGET=$(detect_target)
    if [ -z "$TARGET" ]; then
        echo -e "${YELLOW}Could not auto-detect environment.${NC}"
        echo ""
        echo "Please specify target:"
        echo "  omp   - oh-my-pi"
        echo "  adk   - adk-rust"
        echo "  jcode - jcode"
        echo "  local - current directory"
        echo ""
        read -p "Target: " TARGET
    else
        echo -e "${GREEN}Auto-detected: $TARGET${NC}"
    fi
fi

TARGET_PATH=$(get_target_path "$TARGET")

if [ -z "$TARGET_PATH" ]; then
    echo -e "${RED}Error: Unknown target '$TARGET'${NC}"
    usage
    exit 1
fi

echo ""
echo "Installing kb skill..."
echo "  Source:  $SKILL_DIR"
echo "  Target:  $TARGET_PATH"
echo ""

install_skill "$TARGET_PATH"

echo ""
echo -e "${GREEN}Done! Try:${NC}"
echo "  使用 kb skill 初始化知识库"
