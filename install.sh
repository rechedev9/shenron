#!/usr/bin/env bash
# Install the Shenron skills for Codex, Claude Code, or both.

set -euo pipefail

TARGET="codex"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

usage() {
  echo "Usage: ./install.sh [--target codex|claude|both]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      TARGET="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "${TARGET}" in
  codex|claude|both) ;;
  *)
    echo "Invalid target: ${TARGET}" >&2
    usage >&2
    exit 2
    ;;
esac

for skill in shenron e2e-qa-team; do
  [[ -f "${SCRIPT_DIR}/skills/${skill}/SKILL.md" ]] || {
    echo "Missing skill: ${skill}" >&2
    exit 1
  }
done

install_skill() {
  local product_home="$1"
  local skill="$2"
  local skills_dir="${product_home}/skills"
  local destination="${skills_dir}/${skill}"
  local backup_root="${product_home}/.shenron-backups/${TIMESTAMP}"

  mkdir -p "${skills_dir}"

  if [[ -e "${destination}" ]]; then
    mkdir -p "${backup_root}"
    mv "${destination}" "${backup_root}/${skill}"
    echo "Backed up ${destination} to ${backup_root}/${skill}"
  fi

  mkdir -p "${destination}"
  cp -R "${SCRIPT_DIR}/skills/${skill}/." "${destination}/"
  echo "Installed ${skill} to ${destination}"
}

install_product() {
  local product="$1"
  local product_home

  case "${product}" in
    codex)
      product_home="${CODEX_HOME:-${HOME}/.codex}"
      ;;
    claude)
      product_home="${CLAUDE_HOME:-${HOME}/.claude}"
      ;;
  esac

  install_skill "${product_home}" shenron
  install_skill "${product_home}" e2e-qa-team
}

if [[ "${TARGET}" == "codex" || "${TARGET}" == "both" ]]; then
  install_product codex
fi

if [[ "${TARGET}" == "claude" || "${TARGET}" == "both" ]]; then
  install_product claude
fi

echo "Shenron installation complete."
