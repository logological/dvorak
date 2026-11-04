#!/bin/sh
# Install the custom Dvorak xkb layout (en_de_fr_hu_is).
#
# Usage: install.sh --user-wayland | --system-wayland | --system-x11

set -eu

LAYOUT=dvorak
VARIANT=en_de_fr_hu_is

usage() {
    cat >&2 <<EOF
Usage: $0 OPTION

Install the "$LAYOUT($VARIANT)" xkb layout.  Specify one option:

  --user-wayland     install for the current user (Wayland)
                     into \${XDG_CONFIG_HOME:-\$HOME/.config}/xkb
  --system-wayland   install system-wide (Wayland)
                     into \${XKB_CONFIG_EXTRA_PATH:-/etc/xkb}
  --system-x11       install system-wide (X11) into /usr/share/X11/xkb
EOF
    exit 2
}

die() {
    echo "$0: error: $*" >&2
    exit 1
}

# Process command-line arguments

[ "$#" -eq 1 ] || usage

case $1 in
    --user-wayland)
        MODE=wayland
        INSTALLDIR=${XDG_CONFIG_HOME:-$HOME/.config}/xkb
        ;;
    --system-wayland)
        MODE=wayland
        INSTALLDIR=${XKB_CONFIG_EXTRA_PATH:-/etc/xkb}
        ;;
    --system-x11)
        MODE=x11
        INSTALLDIR=/usr/share/X11/xkb
        ;;
    *)
        usage
        ;;
esac

SRCDIR=$(cd "$(dirname "$0")" && pwd)
SRC_SYMBOLS=$SRCDIR/symbols/dvorak
SRC_RULES=$SRCDIR/rules/evdev.xml

[ -f "$SRC_SYMBOLS" ] || die "missing source file: $SRC_SYMBOLS"
if [ "$MODE" = wayland ]; then
    [ -f "$SRC_RULES" ] || die "missing source file: $SRC_RULES"
    command -v xmlstarlet >/dev/null 2>&1 || die "xmlstarlet is required"
fi

DEST_SYMBOLS=$INSTALLDIR/symbols/dvorak
DEST_RULES=$INSTALLDIR/rules/evdev.xml

# Install symbols

if [ ! -e "$DEST_SYMBOLS" ]; then
    mkdir -p "$INSTALLDIR/symbols"
    cp "$SRC_SYMBOLS" "$DEST_SYMBOLS"
    chmod 644 "$DEST_SYMBOLS"
else
    status=0
    grep -Eq "^([^/]|/[^/])*xkb_symbols[[:space:]]*\"$VARIANT\"" \
        "$DEST_SYMBOLS" || status=$?
    case $status in
        0) die "$DEST_SYMBOLS already defines \"$VARIANT\"" ;;
        1) ;;
        *) die "could not read $DEST_SYMBOLS" ;;
    esac

    { printf '\n'; cat "$SRC_SYMBOLS"; } >>"$DEST_SYMBOLS"
fi

[ "$MODE" = x11 ] && exit 0

# Install rules

if [ ! -e "$DEST_RULES" ]; then
    mkdir -p "$INSTALLDIR/rules"
    cp "$SRC_RULES" "$DEST_RULES"
    chmod 644 "$DEST_RULES"
    exit 0
fi

TMPDIR_=$(mktemp -d "${TMPDIR:-/tmp}/xkb-install.XXXXXX")
trap 'rm -rf "$TMPDIR_"' EXIT HUP INT TERM

# Create working directory containing evdev.xml and xkb.dtd if available
DTD=/usr/share/xkeyboard-config-2/rules/xkb.dtd
WORK=$TMPDIR_/work
mkdir "$WORK"
cp "$DEST_RULES" "$WORK/evdev.xml"
if [ -r "$DTD" ]; then
    cp "$DTD" "$WORK/xkb.dtd"
fi

# count XPATH: print the number of nodes matched by XPATH in the working copy.
count() {
    xmlstarlet sel -t -v "count($1)" "$WORK/evdev.xml"
}

# insert_into PARENT_XPATH SED_ADDRESS
# Append, as last child of PARENT_XPATH in the working copy, the lines of
# $SRC_RULES selected by SED_ADDRESS.  xmlstarlet finds the right spot by
# adding a placeholder element, and sed swaps the placeholder for the text.
insert_into() {
    sed -n "$2p" "$SRC_RULES" >"$TMPDIR_/frag"
    [ -s "$TMPDIR_/frag" ] || die "nothing matched $2 in $SRC_RULES"
    xmlstarlet ed -s "$1" -t elem -n XKBINSERT "$WORK/evdev.xml" >"$TMPDIR_/1"
    xmlstarlet fo --indent-spaces 2 "$TMPDIR_/1" >"$TMPDIR_/2"
    sed -e '/<XKBINSERT\/>/{r '"$TMPDIR_/frag" -e d -e '}' \
        "$TMPDIR_/2" >"$TMPDIR_/3"
    xmlstarlet fo --indent-spaces 2 "$TMPDIR_/3" >"$WORK/evdev.xml"
}

LAYOUT_PATH="/xkbConfigRegistry/layoutList/layout[configItem/name='$LAYOUT']"

[ "$(count "/xkbConfigRegistry/layoutList")" -ge 1 ] \
    || die "$DEST_RULES has no <layoutList> element"

if [ "$(count "$LAYOUT_PATH")" -eq 0 ]; then
    insert_into "/xkbConfigRegistry/layoutList" '/<layout>/,/<\/layout>/'
elif [ "$(count "$LAYOUT_PATH/variantList")" -eq 0 ]; then
    insert_into "$LAYOUT_PATH" '/<variantList>/,/<\/variantList>/'
elif [ "$(count "$LAYOUT_PATH/variantList/variant[configItem/name='$VARIANT']")" \
        -eq 0 ]; then
    insert_into "$LAYOUT_PATH/variantList" '/<variant>/,/<\/variant>/'
else
    die "$DEST_RULES already contains the \"$LAYOUT\" layout with variant \"$VARIANT\""
fi

cat "$WORK/evdev.xml" >"$DEST_RULES"
