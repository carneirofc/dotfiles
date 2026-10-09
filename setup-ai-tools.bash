#!/bin/bash
set -euo pipefail

require() {
    command -v "$1" >/dev/null || { echo "$1 not found; install it first (pacman -S $2)" >&2; exit 1; }
}

function setup_graphifyy {
    # -----------------------------------------
    # https://github.com/Graphify-Labs/graphify
    # -----------------------------------------
    #
    # Create a .graphifyignore in your project root — same syntax as .gitignore, including ! negation.
    # .gitignore is respected automatically. graphify reads the .gitignore in each directory.
    # If a .graphifyignore is also present, the two are merged
    require uv uv

    # Recommended (isolated env; if 'graphify' isn't found after, run: uv tool update-shell):
    uv tool install 'graphifyy[pdf,office,mcp,ollama,bedrock,sql,terraform]'

    # Install on agents
    "$(uv tool dir --bin)/graphify" install

    # Run this once in your project after building a graph:
    # graphify claude install
}

function setup_context7 {
    require npx npm
    npx ctx7 setup
}

setup_graphifyy

setup_context7
