#!/bin/bash
# Install the Claude configs into ~/.claude on Linux/macOS.
#
#   ./claude/install-claude.bash
#
# Copies the agents/ and skills/ folders plus CLAUDE.md and AGENTS.md into
# ~/.claude. Everything is a plain copy (no symlinks); re-running is safe and
# refreshes every destination. Only files git tracks are copied, and nothing
# already in a destination is deleted: locally installed agents and skills
# survive, and a file removed from the repo stays behind until you delete it by
# hand.
set -eu -o pipefail

command -v git >/dev/null || {
    echo "git is required: configs are copied from the files git tracks." >&2
    exit 1
}

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
claude_src="${script_dir}"
claude_dest="${CLAUDE_HOME:-${HOME}/.claude}"

install_file() {
    # $1 source file, $2 destination file
    local src=$1 dest=$2
    [ -f "${src}" ] || return 0
    # Already linked into the repo (see README): nothing to copy.
    [ "${src}" -ef "${dest}" ] && return 0
    mkdir --parent "$(dirname -- "${dest}")"
    cp -av -- "${src}" "${dest}"
}

install_tree() {
    # $1 source dir, $2 destination dir; copies the files git tracks under $1,
    # file by file, deleting nothing in $2.
    local src=$1 dest=$2 file
    [ -d "${src}" ] || return 0
    git -C "${src}" -c core.quotePath=false ls-files -z |
        while IFS= read -r -d '' file; do
            install_file "${src}/${file}" "${dest}/${file}"
        done
}

install_tree "${claude_src}/agents" "${claude_dest}/agents"
install_tree "${claude_src}/skills" "${claude_dest}/skills"
install_file "${claude_src}/CLAUDE.md" "${claude_dest}/CLAUDE.md"
install_file "${claude_src}/AGENTS.md" "${claude_dest}/AGENTS.md"

echo "Claude configs installed into ${claude_dest}"
