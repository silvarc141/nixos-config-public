#!/usr/bin/env bash

# Get required components
# 1. LUKS disk encryption key file
#
# - Generate a new encryption key file
# openssl genrsa -out $luksKey 4096
#
# - Get an existing encryption key file from keepassxc database:
# keepassxc-cli attachment-export $database "dev/luks-key-$configName" "key" $luksKey
#
# 2. AGE key
# 
# ageKey="$(mktemp -d)/key"
#
# - Generate a new age key (remember to add it to config's secrets)
# age-keygen -o $ageKey
# 
# - Get an existing age key from keepassxc database:
# keepassxc-cli show $DATABASE "dev/sops-machine" -a password -s > $ageKey
#
# Usage example 1:
# configName=hsv
# address='root@192.168.8.2'
# luksKey="/run/media/silvarc/KEY/$configName.key"
# openssl genrsa -out "$luksKey" 4096
# ageKey="$(mktemp -d)/key"
# age-keygen -o "$ageKey"
# # now add key to config secrets
# ./install.sh "$configName" "$address" "$ageKey" "$luksKey"
#
# Usage example 2:
# configName=hsv
# address='root@192.168.8.2'
# luksKey="/run/media/silvarc/KEY/$configName.key"
# ageKey="$(mktemp -d)/key"
# database="$HOME/.local/share/passwords/database/passwords.kdbx"
# keepassxc-cli show "$database" "dev/sops-machine" -a password -s > "$ageKey"
# keepassxc-cli attachment-export "$database" "dev/luks-key-$configName" "key" $luksKey
# ./install.sh "$configName" "$address" "$ageKey" "$luksKey"
#
# Usage example 3:
# set -e
# configName='dta'
# address='root@192.168.8.160'
# luksKey="/run/media/silvarc/KEY/$configName.key"
# ageKey="$(mktemp -d)/key"
# database="$HOME/.local/share/passwords/database/passwords.kdbx"
# keepassxc-cli show "$database" "dev/sops-workstation" -a password -s > "$ageKey"
# openssl genrsa -out "$luksKey" 4096
# ./install.sh "$configName" "$address" "$ageKey" "$luksKey"
#
# Usage example 4:
# ageKey="$(mktemp -d)/key" && keepassxc-cli show ~/.local/share/passwords/database/passwords.kdbx "dev/sops-workstation" -a password -s > "$ageKey" && ./install.sh thp root@192.168.8.170 $ageKey
# 
#
# Remote rebuild example:
# nixos-rebuild switch --flake "~/nixos-config#$configName" --target-host silvarc@192.168.8.2 --use-remote-sudo
#
# Secure boot:
# 1. config: disable secure boot
# 2. install system
# 3. sudo sbctl create-keys
# 4. config: enable secure boot
# 5. sudo nixos-rebuild switch
# 6. UEFI: set setup mode / erase options / erase platform key
# 7. sudo sbctl enroll-keys --microsoft
# 8. UEFI: enforce secure boot
#
# Secure boot diagnostics:
# - sudo sbctl status
# - sudo sbctl verify
# - bootctl status

set -e

if [[ "$#" -lt 3 ]]; then
  echo "Usage: $0 <nixos-config-name> <ssh-address> <age-key-local-path> [<disk-encryption-key-local-path>]"
  echo "Example: $0 hsv root@192.168.1.100 ./key.txt"
  exit 1
fi

configName="$1"
sshAddress="$2"
ageKeyLocalPath="$3"
diskEncryptionKeyLocalPath="${4:-}"

echo "Installing NixOS configuration '$configName' to '$sshAddress' with key from '$ageKeyLocalPath'"

nixosAnywhereArgs=(
  --flake .#"$configName" "$sshAddress"
  --phases 'kexec,disko,install'
)

ageTempDir=$(mktemp -d)

cleanup() {
  rm -rf "$ageTempDir"
}
trap cleanup EXIT

# create a relative directory structure for sops age key that will be rsynced to target machine
install -D -m600 "$ageKeyLocalPath" "$ageTempDir/persist/system/key.txt"
nixosAnywhereArgs+=(--extra-files "$ageTempDir")

if [[ -n "$diskEncryptionKeyLocalPath" ]]; then
  # echo -n "Enter disk encryption password for '$configName': "
  # read -s diskEncryptionPassword
  # echo
  
  # if [[ -z "$diskEncryptionPassword" ]]; then
  #   echo "Error: Disk encryption password cannot be empty."
  #   exit 1
  # fi
  
  nixosAnywhereArgs+=(
    --disk-encryption-keys "/key/$configName.key" "$diskEncryptionKeyLocalPath"
    # --disk-encryption-keys /tmp/password <(echo -n "$diskEncryptionPassword")
  )
fi

nix run 'github:nix-community/nixos-anywhere/refs/tags/1.11.0' -- "${nixosAnywhereArgs[@]}"
