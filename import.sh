#!/usr/bin/env bash

# Import legacy content into project directory
#
# Copyright 2015, Outernet Inc.
# Some rights reserved.
# 
# This software is free software licensed under the terms of GPLv3. See COPYING
# file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.

set -e

PKG=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VERSION=$(cat "$PKG/VERSION")

. "$PKG/util/tmputil.sh"
. "$PKG/util/pathutil.sh"
. "$PKG/util/logutil.sh"

help() {
    cat <<EOF
import.sh v$VERSION

Imports a legacy zipball into content repository

Usage: 
    import.sh PATH

Parameters:
    PATH    path to legacy zipball
EOF
}

fail() {
    echo "Import failed. Log file is at $LOGFILE"
    exit 1
}

zipfile=$1

if [ -z "$zipfile" ]
then
    help
    exit 1
fi

if [ ! -f "$zipfile" ]
then
    echo "${zipfile}: file not found"
    exit 1
fi

# Initialize new log file
mklog import_log


filename=$(basename "$zipfile")
cid=${filename%%.*}  # content ID
tmpdir=$(mktmpdir import)
newpath=$OUTERNET_CONTENT/$(splitseg "$cid")

if [ -e "$newpath" ]
then
    echo "$newpath: path already exists"
    exit 1
fi

log Importing $zipfile

echo -n "Extracting content..."
unzip "$zipfile" -d "$tmpdir" 2>&1 | plog || fail
echo done

echo -n "Creating new directory structure..."
mkdir -p "$newpath" 2>&1 | plog || fail
echo done
echo -n "Copying files..."
cp -rv "$tmpdir/$cid"/* "$newpath" 2>&1 | plog || fail
echo done
echo -n "Removing temporary directory..."
rm -rf "$tmpdir" 2>&1 | plog || fail
echo done
echo "Log file is available at $LOGFILE"
