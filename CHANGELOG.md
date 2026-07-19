# Changelog

All notable changes to this repo are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Conventional Commits](https://www.conventionalcommits.org/).

## [Unreleased]

### Added
- **fastfetch**: modern `linux/fastfetch/config.jsonc` with clean Nerd Font
  icon rows, the repo's Nord palette, and memory/disk bars (root only). Deployed
  by the `setup-workstation` ansible role (`setup_fastfetch` toggle) or via the
  cwd-independent `linux/fastfetch/setup.bash`, which symlinks it into
  `~/.config/fastfetch`. Documented in the README.

### Changed
- **claude**: capitalized the `explore` and `implementer` subagent names.
