#!/bin/bash
# One-command Linux setup: run from anywhere, paths resolve relative to this
# script.
#
#   ./linux/setup-linux.bash                     # playbook + claude + ssh
#   ./linux/setup-linux.bash --wifi --ai-tools   # plus the optional steps
#   ./linux/setup-linux.bash -- --check          # args after -- go to ansible
#
# Steps, in order:
#   ansible   linux/bootstrap.sh: system upgrade + the setup-workstation
#             playbook (packages, git, zsh, terminals, zellij, theming, ...)
#   claude    claude/install-claude.bash: agents, skills, CLAUDE.md -> ~/.claude
#   ssh       common/ssh/setup.bash: ~/.ssh/config + sockets dir
#   wifi      linux/network/setup.bash: NetworkManager power-save drop-in
#             (opt-in, needs sudo; for Intel Wi-Fi cards)
#   ai-tools  setup-ai-tools.bash: graphify + context7 (opt-in, needs uv/npx)
#
# Every step is idempotent, so re-running refreshes everything.
set -eu -o pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(dirname -- "${script_dir}")

usage() {
    cat <<EOF
usage: $(basename "$0") [options] [-- ansible-playbook args]

  --no-ansible   skip the playbook (linux/bootstrap.sh)
  --no-claude    skip the Claude Code config install
  --no-ssh       skip the SSH client config
  --wifi         also install the Wi-Fi power-save drop-in (sudo)
  --ai-tools     also install graphify and context7
  -h, --help     show this help
EOF
}

run_ansible=1 run_claude=1 run_ssh=1 run_wifi=0 run_ai_tools=0
ansible_args=()

while (($#)); do
    case $1 in
    --no-ansible) run_ansible=0 ;;
    --no-claude) run_claude=0 ;;
    --no-ssh) run_ssh=0 ;;
    --wifi) run_wifi=1 ;;
    --ai-tools) run_ai_tools=1 ;;
    -h | --help) usage; exit 0 ;;
    --) shift; ansible_args=("$@"); break ;;
    *) usage >&2; exit 1 ;;
    esac
    shift
done

step() { printf '\n==> %s\n' "$*"; }

# bootstrap.sh execs ansible-playbook, so run it as a child, not sourced.
((run_ansible)) && { step "ansible playbook"; "${script_dir}/bootstrap.sh" "${ansible_args[@]}"; }
((run_claude)) && { step "claude config"; "${repo_root}/claude/install-claude.bash"; }
((run_ssh)) && { step "ssh config"; "${repo_root}/common/ssh/setup.bash"; }
((run_wifi)) && { step "wifi power save"; "${script_dir}/network/setup.bash"; }
((run_ai_tools)) && { step "ai tools"; "${repo_root}/setup-ai-tools.bash"; }

step "done"
