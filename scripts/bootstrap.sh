#!/usr/bin/env bash
# Copyright (c) Andrei Jiroh Halili
# SPDX-License-Identifier: MPL-2.0
# 
# OS detection adapted from Tailscale's install script at
# https://tailscale.com/install.sh and is licensed under
# BSD-3-Clause.

set -e

if [[ $DEBUG != "" ]]; then
  set -x
fi

main() {
    BASE_DIR=$(dirname $0)
    # Step 1: detect the current linux distro, version, and packaging system.
	#
	# We rely on a combination of 'uname' and /etc/os-release to find
	# an OS name and version, and from there work out what
	# installation method we should be using.
	#
	# The end result of this step is that the DETECTED_OS will be
    # populated by default, expect in some edge cases (like in Termux).
    if [ -f "/etc/os-release" ]; then
        . "/etc/os-release"
        case "$ID" in
        	ubuntu|pop|neon|zorin|tuxedo)
				DETECTED_OS="ubuntu"
				if [ "${UBUNTU_CODENAME:-}" != "" ]; then
				    VERSION="$UBUNTU_CODENAME"
				else
				    VERSION="$VERSION_CODENAME"
				fi
				# Third-party keyrings became the preferred method of
				# installation in Ubuntu 20.04.
				if expr "$VERSION_ID" : "2.*" >/dev/null; then
					APT_KEY_TYPE="keyring"
				else
					APT_KEY_TYPE="legacy"
				fi
				;;
			debian)
				DETECTED_OS="$ID"
				VERSION="$VERSION_CODENAME"
				# Third-party keyrings became the preferred method of
				# installation in Debian 11 (Bullseye).
				if [ -z "${VERSION_ID:-}" ]; then
					# rolling release. If you haven't kept current, that's on you.
					APT_KEY_TYPE="keyring"
				elif [ "$VERSION_ID" -lt 11 ]; then
					APT_KEY_TYPE="legacy"
				else
					APT_KEY_TYPE="keyring"
				fi
				;;
            arch|archarm|endeavouros|blendos|garuda)
                DETECTED_OS="arch"
                ;;
            alpine)
                DETECTED_OS="alpine"
                ;;
        esac
    fi

    if [ -z "${DETECTED_OS}" ]; then
        if type uname >/dev/null 2>&1; then
            case "$(uname)" in
                Linux)
                    if [ "${TERMUX_VERSION}" == "" && "${ANDROID_ASSETS}" == "/system/app" ]; then
                        DETECTED_OS="android"
                        TERMUX=true
                    else
                        DETECTED_OS="other-linux"
                    fi
            esac
        fi
    fi

	# Ideally we want to use curl, but on some installs we
	# only have wget. Detect and use what's available.
    "$BASE_DIR/prebootstrap.sh"
	# After the preflight checks, hand off to distro-specific scripts
    if [ -d "$BASE_DIR/${DETECTED_OS}" ]; then
        for script in $(ls -A ${BASE_DIR}/${DETECTED_OS}); do
            echo "[info] executing "${BASE_DIR}/${DETECTED_OS}/$script""
            "${BASE_DIR}/${DETECTED_OS}/$script"
        done
	else
		echo "[error] We currently don't support your distro or OS yet. Send us"
		echo "[error] a patch to make it work."
		exit 1
    fi
}

main