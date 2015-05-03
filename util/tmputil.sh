#!/usr/bin/env bash

# Tools for working with temporary directories
#
# Copyright 2015, Outernet Inc.
# Some rights reserved.
# 
# This software is free software licensed under the terms of GPLv3. See COPYING
# file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
# 

SYSTEMP=${TMPDIR:-/tmp}

# mktmpdir(pfx)
# =============
#
# Creates a temporary directory and echos the path. The temporary diretory is 
# created under the system temporary directory. The directory name is based on 
# current time and optional prefix $pfx.
#
# Default prefix is 'tmp'.
#
# The temporary directory is not automatically cleaned up (except when the 
# operating system performs this task).
#
# Example:
#
#     $ mktmpdir foo
#     /tmp/foo.1429716349
#
#     $ mkdtmpdir
#     /tmp/tmp.1429716349
#
mktmpdir() {
    pfx=${1:-tmp}
    dname="${SYSTEMP}/${pfx}.$(date +%s)"
    mkdir -p "$dname"
    echo $dname
}


# mktmppath(pfx, $ext)
# ==============
#
# Createa blank temporary file and echoes the path. The temporary file is 
# created under the system temporary directory. The file name is based on 
# current time and optional prefix $pfx.
#
# Default prefix is 'tmp'
#
# Optionally, extension may be supplied. The extension defaults to blank.
#
# Temporary file is not automatically cleaned up (except when the operating 
# system performs this task).
#
# Example:
#
#     $ mktmppath foo
#     /tmp/foo-1429716349
#
#     $ mktmppath foo js
#     /tmp/foo-1429716349.js
#
#     $ mktmppath
#     /tmp/tmp-1429716349
#
mktmppath() {
    pfx=${1:-tmp}
    ext=$2
    fname=${SYSTEMP}/${pfx}-$(date +%s)
    if [ ! -z "$ext" ];
    then
        fname=${fname}.${ext}
    fi
    touch "$fname"
    echo "$fname"
}
