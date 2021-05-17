#!/usr/bin/env python
# encoding: UTF-8

"""list information about the repository
"""

__author__  = 'Rogier Steehouder'
__date__    = '2018-04-05'
__version__ = '0.2'

from collections import defaultdict

from mercurial import registrar

cmdtable = {}
command = registrar.command(cmdtable)

def hginfo_path_cmp(a, b):
    """Sort paths so default (-pull, -push) are first."""
    if a[0] == 'default': return -1
    if b[0] == 'default': return 1
    if a[0] == 'default-push': return -1
    if b[0] == 'default-push': return 1
    return cmp(a, b)

def hginfo_heads(repo):
    """Show all heads in the repository."""
    result = defaultdict(list)
    for r in repo:
        if not repo[r].children():
            result[repo[r].branch()].append(r)
    return dict(result)

@command('info', [], '')
def hginfo(ui, repo):
    """List the following information about the repository:

    - username
    - root directory
    - base hash (hash of revision 0, close to a unique identifier)
    - number of revisions
    - current revision
    - number of files
    - paths to linked repositories, if any
    - warning if current revision is not tip
    - warning if uncommitted changes are present
    - warning if multiple heads are present
    """
    result = []
    extended = []
    warning = []

    cur = repo[None].parents()[0].rev()
    tip = repo['tip'].rev()

    result.append('Username: {}'.format(ui.username()))
    result.append('Repository: {}'.format(repo.root))
    result.append('Base Hash: {}'.format(repo[0].hex()))
    result.append('Revisions: {}'.format(len(repo)))
    result.append('Current revision: {} ({})'.format(cur, ('NOT tip', 'tip')[cur == tip]))
    result.append('Files in current revision: {}'.format(len(repo[cur].manifest())))

    paths = sorted(ui.configitems('paths'), cmp=hginfo_path_cmp)
    if len(paths) > 0:
        result.append('Linked repositories:')
        for p in paths:
            result.append('    {}: {}'.format(p[0], p[1]))

    if cur != tip:
        warning.append('Working directory is not linked to tip.')

    if sum(len(x) for x in repo.status()[:4]) > 0:
        warning.append('Uncommitted changes present.')

    branches = hginfo_heads(repo)
    if sum(len(v) for k, v in branches.items()) > 1:
        warning.append('Multiple heads present:')
        for k, v in branches.items():
            heads = []
            for x in v:
                heads.append(str(x))
                if x == cur == tip:
                    heads[-1] += ' (current, tip)'
                elif x == cur:
                    heads[-1] += ' (current)'
                elif x == tip:
                    heads[-1] += ' (tip)'
            warning.append('    {}: {}' % (k, ', '.join(heads)))

    #print '=== BEGIN DEBUG ==='
    #print '=== END DEBUG ==='

    if extended:
        result.append('')
        result.extend(extended)
    if warning:
        result.append('')
        result.extend(warning)

    result.append('')
    ui.write('\n'.join(result))

cmdtable = {
    'info': (hginfo, [], 'hg info')
}

if __name__ == '__main__':
    print('This is a Mercurial plugin and does not run on its own.')
