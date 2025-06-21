#!/usr/bin/env bash

# Example 1:
# ./install.sh hsv root@192.168.8.2 ./age-key.txt ./luks-key
#
# Example 2:
# DATABASE="$HOME/.local/share/passwords/database/passwords.kdbx"
# AGEKEY="$(mktemp -d)/key"
# LUKSKEY="$(mktemp -d)/key"
# keepassxc-cli show $DATABASE "dev/sops-machine" -a password -s > $AGEKEY
# keepassxc-cli attachment-export $DATABASE "dev/luks-key-hsv" "key" $LUKSKEY
# ./install.sh hsv root@192.168.8.2 $AGEKEY $LUKSKEY
#
# Generate keyfile with openssl:
# openssl genrsa -out $DEST 4096
#
# Write keyfile stored in keepass database
# keepassxc-cli attachment-export $DATABASE "dev/luks-key-hsv" "key" "/run/media/silvarc/KEY/$nixosConfigName.key"
# 
# For encryption key to be typable on keyboard, newlines have to be correct
# Correct typable key example:
# `echo -n abcd12345 > keyfile` # the -n suppresses the trailing newline
#
# Remote rebuild example:
# nixos-rebuild switch --flake ~/nixos-config#hsv --target-host servarc@192.168.8.2 --use-remote-sudo

nixosConfigName="$1"
sshAddress="$2"
ageKeyLocalPath="$3"
diskEncryptionKeyLocalPath="$4"

# create temp dir for age key relative directory structure
ageTempDir=$(mktemp -d)

# cleanup when script exits
cleanup() {
  rm -rf "$ageTempDir"
}
trap cleanup EXIT

# create a relative directory structure for sops age key that will be rsynced to target machine
install -D -m600 "$ageKeyLocalPath" "$ageTempDir/persist/system/key.txt"

nix run github:nix-community/nixos-anywhere -- \
  --flake .#"$nixosConfigName" "$sshAddress" \
  --no-reboot \
  --extra-files "$ageTempDir" \
  --disk-encryption-keys "/key/$nixosConfigName.key" "$diskEncryptionKeyLocalPath" \
