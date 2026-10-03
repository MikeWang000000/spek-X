#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  touch config.rpath &&
  {
    # gettext >= 0.24.1 moved its m4 macros out of aclocal's default search
    # path, into $datadir/gettext/m4.
    gettext_m4dir="$(dirname "$(command -v gettextize)")/../share/gettext/m4"
    if test -f "$gettext_m4dir/gettext.m4"; then
      ACLOCAL_PATH="$gettext_m4dir${ACLOCAL_PATH:+:$ACLOCAL_PATH}"
      export ACLOCAL_PATH
    fi
  } &&
  # autoconf >= 2.73 reruns aclocal with "-I m4"; ensure it exists.
  mkdir -p m4 &&
  AUTOPOINT='intltoolize --automake --copy' autoreconf -fiv
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"