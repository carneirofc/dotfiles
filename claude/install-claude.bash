#!/bin/bash
# Install the Claude configs into ~/.claude on Linux/macOS.
#
#   ./claude/install-claude.bash
#
# Copies the agents/ and skills/ folders plus CLAUDE.md and AGENTS.md into
# ~/.claude. Everything is a plain copy (no symlinks); re-running is safe and
# refreshes every destination. Stale destinations are removed first so upstream
# deletions propagate on re-run.
set -eu -o pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
claude_src="${script_dir}"
claude_dest="${CLAUDE_HOME:-${HOME}/.claude}"

install_dir() {
    # $1 source dir, $2 destination dir
    local src=$1 dest=$2
    [ -d "${src}" ] || return 0
    mkdir --parent "$(dirname -- "${dest}")"
    rm -rf -- "${dest}"
    cp -av -- "${src}" "${dest}"
}

install_file() {
    # $1 source file, $2 destination file
    local src=$1 dest=$2
    [ -f "${src}" ] || return 0
    mkdir --parent "$(dirname -- "${dest}")"
    cp -av -- "${src}" "${dest}"
}

install_dir  "${claude_src}/agents" "${claude_dest}/agents"
install_dir  "${claude_src}/skills" "${claude_dest}/skills"
install_file "${claude_src}/CLAUDE.md" "${claude_dest}/CLAUDE.md"
install_file "${claude_src}/AGENTS.md" "${claude_dest}/AGENTS.md"

echo "Claude configs installed into ${claude_dest}"
