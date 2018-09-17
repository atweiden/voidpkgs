#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# seed-diff-upstream-srcpkgs.sh: seed diff.p6 atw/voidpkgs void/void-packages
# -----------------------------------------------------------------------------

# ==============================================================================
# constants {{{

# path to this script
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# path to https://github.com/atweiden/voidpkgs
readonly ROOT_ATW="$(realpath "$DIR/..")"
# path to https://github.com/atweiden/voidpkgs/srcpkgs
readonly SRCPKGS_ATW="$ROOT_ATW/srcpkgs/"
# path to https://github.com/void-linux/void-packages
readonly ROOT_VOID="$HOME/Sandbox/void-linux/void-packages"
# path to https://github.com/void-linux/void-packages/srcpkgs
readonly SRCPKGS_VOID="$ROOT_VOID/srcpkgs/"
# target pkgs, directories only
readonly PKGS=($(find "$SRCPKGS_ATW" -mindepth 1 -maxdepth 1 -type d \
  | while read -r _p; do basename "$_p"; done))

# end constants }}}
# ==============================================================================
# global variables {{{

declare -A pkgs_atw
declare -A pkgs_void

# end global variables }}}
# ==============================================================================

gen_path_srcpkgs() {
  local subject
  subject="${1^^}"
  var="SRCPKGS_$subject"
  echo "${!var}"
}

mkpkgs() {
  # subject must be atw or void
  local subject
  subject="$1"

  local path_srcpkgs
  local path_template

  unset maintainer
  unset pkgname
  unset version
  unset revision
  unset short_desc
  unset license

  for _pkg in ${PKGS[@]}; do
    path_srcpkgs="$(gen_path_srcpkgs "$subject")"
    path_template="$path_srcpkgs/$_pkg/template"
    if [[ -e "$path_template" ]]; then
      # silence the many error messages which surface when sourcing templates
      source "$path_template" 2>/dev/null
    else
      continue
    fi
    eval pkgs_$subject["$_pkg.maintainer"]="\"$maintainer\""
    eval pkgs_$subject["$_pkg.pkgname"]="\"$pkgname\""
    eval pkgs_$subject["$_pkg.version"]="\"$version\""
    eval pkgs_$subject["$_pkg.revision"]="\"$revision\""
    eval pkgs_$subject["$_pkg.short_desc"]="\"$short_desc\""
    eval pkgs_$subject["$_pkg.license"]="\"$license\""
    # clean up environment
    unset maintainer
    unset pkgname
    unset version
    unset revision
    unset short_desc
    unset license
    unset path_srcpkgs
    unset path_template
  done
}

main_atw() {
  mkpkgs "atw"
  for k in "${!pkgs_atw[@]}"; do
    echo "$k = \"${pkgs_atw[$k]}\""
  done
}

main_void() {
  mkpkgs "void"
  for k in "${!pkgs_void[@]}"; do
    echo "$k = \"${pkgs_void[$k]}\""
  done
}

main() {
  echo "[atw]"
  main_atw | sort
  echo
  echo "[void]"
  main_void | sort
}

main

# vim: set filetype=sh foldmethod=marker foldlevel=0:
