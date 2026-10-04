#!/usr/bin/env bash
# Rewrites runic's output where runic gets Odin wrong. Run by `make generate` after runic,
# once per package: scripts/postprocess.sh gdkpixbuf. Deterministic: the same runic output
# always gives the same file. Every rule is listed in docs/PATCHED.md.
#
# The rules are odin-gtk's (MIT, docs/LICENSE-odin-gtk.md), kept where they still apply to
# runic 0.8 on the system headers, in the form odin-glib's postprocess.sh uses.
set -euo pipefail

pkg=${1:?usage: postprocess.sh gdkpixbuf}
file="$pkg/$pkg.odin"
[ -f "$file" ] || { echo "postprocess: $file not found" >&2; exit 2; }

case "$pkg" in
gdkpixbuf)
    # `typedef struct _GdkFoo GdkFoo` comes out as `Foo :: _GdkFoo` plus `_GdkFoo :: ...`: drop
    # the alias, rename the struct. gchar * is a typedef'd char pointer, which runic leaves as
    # ^char: strings become cstring, byte buffers ^byte, string vectors [^]cstring. The macro
    # constants runic quotes as strings become Odin expressions. Byte buffers (guchar *, guint8 *,
    # and the gchar * of the save callback and save_to_buffer) are runs of bytes callers index:
    # [^]u8, not ^u8. `parameters: declared` writes ^T for every parameter and a return type never
    # gets a multi-pointer, so the rules name the declarations.
    sed -i "$file" \
        -e 's#^\([a-zA-Z][a-zA-Z_0-9]*\)\s*::\s*_Gdk\1$##' \
        -e 's#\b_Gdk\([A-Z]\)#\1#g' \
        -e 's/buf: \^glib\.char/buf: [^]u8/g' \
        -e 's/buffer: \^\^glib\.char/buffer: ^[^]u8/g' \
        -e '/^    pixbuf_\(get_pixels\|get_pixels_with_length\|read_pixels\) :: / s/-> \^glib\.\(uchar\|uint8\)/-> [^]u8/' \
        -e '/^    pixbuf_\(new_from_data\|new_from_inline\|loader_write\) :: / s/\(data\|buf\): \^glib\.\(uchar\|uint8\)/\1: [^]u8/' \
        -e '/^PixbufDestroyNotify :: / s/pixels: \^glib\.uchar/pixels: [^]u8/' \
        -e 's/\[\^\]\^glib\.char/[^]cstring/g' \
        -e 's/-> \^\^glib\.char/-> [^]cstring/g' \
        -e 's/\^glib\.char/cstring/g' \
        -e '/^\(MAJOR\|MINOR\|MICRO\) ::/s/[`()]//g' \
        -e '/^TYPE_/{s/`//g; s/(gdk_//; s/ ())//}' \
        -e '/^ERROR ::/{s/`//g; s/gdk_//; s/ ()//}'
    ;;
*)
    echo "postprocess: unknown package $pkg" >&2
    exit 2
    ;;
esac

