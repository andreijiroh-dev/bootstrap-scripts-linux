#!/usr/bin/env bash
# Copyright (c) Andrei Jiroh Halili
# SPDX-License-Identifier: MPL-2.0
set -e

if [[ $DEBUG != "" ]]; then
  set -x
fi

. "$(dirname $0)/lib/import-sh"

# Ideally we want to use curl, but on some installs we
# only have wget. Detect and use what's available.
CURL=
if type curl >/dev/null; then
  CURL="curl -fsSL"
elif type wget >/dev/null; then
  CURL="wget -q -O-"
fi
if [ -z "$CURL" ]; then
  echo "The installer needs either curl or wget to download files."
  echo "Please install either curl or wget to proceed."
  exit 1
fi

PING_SITE=${PING_SITE:-"https://proxyparty.recaptime.dev"}
RC=0
TEST_OUT=$($CURL "$PING_SITE" 2>&1) || RC=$?

if [ $RC != 0 ]; then
	echo "The installer cannot reach $TEST_URL"
	echo "Please make sure that your machine has internet access."
	echo "Test output:"
	echo $TEST_OUT
	exit 1
fi
export CURL
