#!/usr/bin/env python3

# This script adds MO files to resource file, and compiles spek.rc to spek.res file.

# Both GNU windres and llvm-windres do not accept characters other than [A-Za-z0-9_] in resource name IDs.
# However, this will leads wxWidgets not loading MO files like "spek_sr@latin".
# Some hacky workarounds are used in this Python script.

# Note: This script only accepts Windows style paths.

import re
import os
import sys
import glob

WINDRES = sys.argv[1]
WX_PREFIX = sys.argv[2]
LANGUAGES = sys.argv[3:]

token_map = {}

# Replaces invalid characters to '_' and stores mapping relations.
def safe_token(token):
    safe = re.sub(r'[^A-Za-z0-9_]', '_', token)
    if safe != token:
        token_map[safe] = token
    return safe

def wxstd_path(lang):
    paths = glob.glob(f'{WX_PREFIX}/share/locale/{lang}/LC_MESSAGES/wxstd*.mo')
    if paths:
        return paths[0]


os.chdir(os.path.dirname(__file__))

rc_content = '#include "spek.rc"\n'
for lang in LANGUAGES:
    token = safe_token(f'spek_{lang}')
    rc_content += f'{token} MOFILE "../../po/{lang}.gmo"\n'
    wxstd_mo = wxstd_path(lang)
    if wxstd_mo:
        token = safe_token(f'wxstd_{lang}')
        rc_content += f'{token} MOFILE "{wxstd_mo}"\n'

with open('spek-all.rc', 'w') as fo:
    fo.write(rc_content)

# Compile RC File
ret = os.system(f'"{WINDRES}" spek-all.rc -O coff -o spek.res')
if ret != 0:
    exit(1)

# Hack: Restore original resource IDs by editing the binary file.
# This workaround is not always safe.
with open('spek.res', 'rb+') as f:
    content = f.read()
    for token in token_map:
        old_token = token.upper().encode('UTF-16-LE')
        new_token = token_map[token].upper().encode('UTF-16-LE')
        content = content.replace(old_token, new_token)
    f.seek(0)
    f.write(content)

# Clean up
os.remove('spek-all.rc')
