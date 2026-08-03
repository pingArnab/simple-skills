#!/bin/sh
set -eu

skill="all"
harness="auto"
project="."
target=""
force="false"

usage() {
  printf '%s\n' "Usage: ./install.sh [--skill all|ask-first|demo-first] [--harness auto|agents|codex|claude|copilot|all] [--project PATH] [--target PATH] [--force]"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skill) skill=${2:?"--skill requires a value"}; shift 2 ;;
    --harness) harness=${2:?"--harness requires a value"}; shift 2 ;;
    --project) project=${2:?"--project requires a value"}; shift 2 ;;
    --target) target=${2:?"--target requires a value"}; shift 2 ;;
    --force) force="true"; shift ;;
    --help|-h) usage; exit 0 ;;
    *) printf '%s\n' "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$skill" in all|ask-first|demo-first) ;; *) printf '%s\n' "Invalid skill: $skill" >&2; exit 2 ;; esac
case "$harness" in auto|agents|codex|claude|copilot|all) ;; *) printf '%s\n' "Invalid harness: $harness" >&2; exit 2 ;; esac

case "$0" in
  */*) script_dir=${0%/*} ;;
  *) script_dir=. ;;
esac
repo_dir=$(CDPATH= cd -- "$script_dir" && pwd -P)
project_abs=$(CDPATH= cd -- "$project" && pwd -P)

if [ "$skill" = "all" ]; then
  skill_names="ask-first demo-first"
else
  skill_names=$skill
fi

if [ -n "$target" ]; then
  case "$target" in
    /*) destinations=$target ;;
    *) destinations=$project_abs/$target ;;
  esac
else
  case "$harness" in
    agents|codex) destinations=$project_abs/.agents/skills ;;
    claude) destinations=$project_abs/.claude/skills ;;
    copilot) destinations=$project_abs/.github/skills ;;
    all) destinations=$(printf '%s\n%s\n%s' "$project_abs/.agents/skills" "$project_abs/.claude/skills" "$project_abs/.github/skills") ;;
    auto)
      destinations=""
      if [ -d "$project_abs/.agents" ]; then destinations=$project_abs/.agents/skills; fi
      if [ -d "$project_abs/.claude" ]; then destinations=$(printf '%s%s%s' "$destinations" "${destinations:+
}" "$project_abs/.claude/skills"); fi
      if [ -d "$project_abs/.github/skills" ]; then destinations=$(printf '%s%s%s' "$destinations" "${destinations:+
}" "$project_abs/.github/skills"); fi
      if [ -z "$destinations" ]; then destinations=$project_abs/.agents/skills; fi
      ;;
  esac
fi

for name in $skill_names; do
  if [ ! -f "$repo_dir/skills/$name/SKILL.md" ]; then
    printf '%s\n' "Packaged skill is missing: $repo_dir/skills/$name" >&2
    exit 1
  fi
done

old_ifs=$IFS
IFS='
'
set -- $destinations
IFS=$old_ifs

for destination_root in "$@"; do
  for name in $skill_names; do
    final=$destination_root/$name
    if [ -e "$final" ] && [ "$force" != "true" ]; then
      printf '%s\n' "Skill already exists at '$final'. Re-run with --force to replace it." >&2
      exit 1
    fi
  done
done

for destination_root in "$@"; do
  mkdir -p -- "$destination_root"
  for name in $skill_names; do
    final=$destination_root/$name
    if [ -e "$final" ]; then rm -rf -- "$final"; fi
    cp -R -- "$repo_dir/skills/$name" "$final"
    printf '%s\n' "Installed $name -> $final"
  done
done
