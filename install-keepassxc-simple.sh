#!/usr/bin/env bash

# BROKEN WHEN INTERACTIVE: does not allow for interactive login, fix

set -e

if [[ "$#" -lt 4 ]]; then
  echo "Usage: $0 <nixos-config-name> <ssh-address> <keepassxc-database> <keepassxc-address> [<disk-encryption-key-local-path>]"
  echo "Example: $0 hsv root@192.168.1.100 ~/passwords/database.kdbx 'dev/sops-workstation'"
  exit 1
fi

configName="$1"
sshAddress="$2"
database="$3"
keepassxcAddress="$4"

ageKey="$(mktemp -d)/key"

cleanup() {
  rm -rf "$ageKey"
}
trap cleanup EXIT

keepassxc-cli show "$database" "$keepassxcAddress" -a password -s > "$ageKey"

./install.sh "$configName" "$sshAddress" "$ageKey"
