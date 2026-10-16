# Patched bindings

The bindings are generated from the C headers by runic 0.8 in Amber's fork (`../runic`, branch `amber-patched`).
Regenerating overwrites hand fixes, so each is also pinned by a typed variable in the
package's `patched.odin`: a regeneration that drops a patch fails to compile there instead
of misbehaving at run time.

To regenerate, run `make generate` and then `make ci`.

## Generation rules

`scripts/postprocess.sh gdkpixbuf` applies these to `gdkpixbuf/gdkpixbuf.odin`. They are
odin-gtk's rules, trimmed to what runic 0.8 produces from the system headers, in the form
odin-glib uses.

| rule | reason |
|---|---|
| `Foo :: _GdkFoo` is deleted and `_GdkFoo` becomes `Foo` | one name per struct |
| `^glib.char` becomes `cstring`; `buf: ^glib.char` becomes `[^]u8`, `buffer: ^^glib.char` `^[^]u8`, `[^]^glib.char` and a `^^glib.char` result `[^]cstring` | `gchar *` is a typedef'd char pointer, which runic leaves as `^char` |
| Byte buffers are `[^]u8`: `pixbuf_get_pixels`, `pixbuf_get_pixels_with_length` and `pixbuf_read_pixels` return it; the `data` parameter of `pixbuf_new_from_data` and `pixbuf_new_from_inline`, the `buf` of `pixbuf_loader_write` and `PixbufSaveFunc`, and the `pixels` of `PixbufDestroyNotify` are one; the `buffer` out-parameter of `pixbuf_save_to_buffer` and `pixbuf_save_to_bufferv` is `^[^]u8` | C `guchar *` and `guint8 *` point at runs of bytes (pixels, encoded data) that callers index; runic writes `^u8` | `_pin_pixbuf_get_pixels`, `_pin_pixbuf_get_pixels_with_length`, `_pin_pixbuf_read_pixels`, `_pin_pixbuf_new_from_data`, `_pin_pixbuf_new_from_inline`, `_pin_pixbuf_loader_write`, `_pin_pixbuf_save_to_buffer`, `_pin_pixbuf_save_to_bufferv`, `_pin_destroy_notify`, `_pin_save_func` |
| `MAJOR`, `MINOR`, `MICRO` lose backticks and parentheses | macro text runic quotes as a string |
| `TYPE_*` and `ERROR` lose backticks, the `gdk_` prefix and the call, so `TYPE_PIXBUF` names `pixbuf_get_type` | macro text runic quotes as a string |

The `GDK_PIXBUF_VERSION*` macros (`VERSION_2_0` … `VERSION_MAX_ALLOWED`, `VERSION`) are
ignored by generation: they are shifts and strings runic cannot express. `MAJOR`, `MINOR`
and `MICRO` are kept for the version test.

`parameters: declared` writes `^T` for every procedure parameter, callback typedefs keep runic's
name heuristic (which is why `PixbufDestroyNotify`'s `pixels` is rewritten from `^glib.uchar`),
and a return type never gets a multi-pointer, so the buffers are rewritten by name in
`postprocess.sh`. Left as they are: the scalar `guchar`
parameters of `pixbuf_add_alpha`; the `guint *` length out-parameter of
`pixbuf_get_pixels_with_length` (one value, not a run); `pixbuf_new_from_xpm_data`'s `char **`
(`^cstring`, strings, not bytes); `glib.Bytes` parameters (`pixbuf_new_from_bytes`,
`pixbuf_loader_write_bytes`, `pixbuf_read_pixel_bytes`), which are opaque. `gdk-pixdata.h` and
`gdk-pixbuf-io.h` are not part of `gdk-pixbuf.h` and are not bound.

## Hand fixes

None beyond the rules above. A hand fix gets a row here and a typed pin in `gdkpixbuf/patched.odin`.

## Single-object parameters

`parameters: declared` in `gdkpixbuf/rune.yml` makes every procedure parameter `^T` unless `arrays:` lists it. Every `[^]` parameter whose name ends in `s` was read against `gdk-pixbuf.h`: `option_keys` and `option_values` of `pixbuf_savev`, `pixbuf_save_to_callbackv`, `pixbuf_save_to_bufferv`, `pixbuf_save_to_streamv` and `pixbuf_save_to_streamv_async` are NULL-terminated `char **` arrays and are listed under `arrays:`; `pixels` of `PixbufDestroyNotify` is a byte buffer (a `postprocess.sh` rule), so none is a single object. `scripts/check-generated.sh` (in `make lint`) pins the byte buffers the rules above make `[^]u8` and fails if runic's `^u8` returns.

## Out-parameters (`T **`)

runic writes `[^]^T` for some `T **` parameters; an out-parameter that returns one pointer must be `^^T`. Every `[^]^T` and `^[^]^T` in the generated output was read against the headers: none is a single-pointer out-parameter, so none is rewritten (under `declared` a `T **` is `^^T` anyway). `scripts/check-generated.sh` fails on any `[^]^T` that is not in its `pointer_vectors` list, so a new one is noticed on the next `make generate`.
