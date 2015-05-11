"""
Git wrapper functions

Copyright 2015, Outernet Inc.
Some rights reserved.

This software is free software licensed under the terms of GPLv3. See COPYING
file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
"""

import os
import subprocess

from . import path
from . import __version__


class GitError(Exception):
    def __init__(self, stdout):
        self.stdout = stdout
        super(GitError, self).__init__(stdout)


def git(*cmd, **kwargs):
    repo = kwargs.pop('repo', path.POOLDIR)
    cmd = ('git',) + cmd
    p = subprocess.Popen(cmd, cwd=repo, stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    p.wait()
    if p.returncode != 0:
        raise GitError(p.stderr.read())
    return p.stdout.read()


def init(repo=path.POOLDIR):
    git('init')
    vfile = os.path.join(repo, '.version')
    with open(vfile, 'w') as f:
        f.write(__version__ + '\n')
    git('add', vfile)
    git('commit', '--author', 'Outernet Broadman <apps@outernet.is>', '-m',
        'Initialized content pool')