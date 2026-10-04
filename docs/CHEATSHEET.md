# odin-gdk-pixbuf cheat sheet

One screen per job: the calls a program makes, in the order it makes them, and the few rules
worth remembering. This is the part of gdk-pixbuf a program uses: load, transform, save, read
the pixels, decode a stream and walk an animation. Every name here is a public declaration in
[API.md](API.md), and `make lint` fails when one is not. Every code block is compiled against
the binding before it is committed.

Conventions that hold everywhere: the package is `gdkpixbuf` and programs import it as
`pixbuf` (`import pixbuf "pixbuf:gdkpixbuf"`), so `gdk_pixbuf_new_from_file` is
`pixbuf.pixbuf_new_from_file`; a call that can fail takes a `^^glib.Error` last and returns nil
or false, and you free the error with `glib.error_free`; enums are named by member, `.RGB`,
`.BILINEAR`; a `glib.boolean` is a `b32`: pass a literal `true`, convert a variable with
`glib.boolean(v)`, and test a result with `if` or `bool(...)`. Pixbuf and its loaders are GObjects: `gobj` is `import gobj "glib:gobject"`.

## pixbuf:gdkpixbuf — load, transform and save

```odin
import glib "glib:glib"
import gobj "glib:gobject"
import pixbuf "pixbuf:gdkpixbuf"

gerr: ^glib.Error
pb := pixbuf.pixbuf_new_from_file("photo.jpg", &gerr)     // transfer full: you own one reference
if pb == nil {
	_ = string(gerr.message)                              // text for the user
	glib.error_free(gerr)                                 // the error is yours too
	return
}
defer gobj.object_unref(pb)

turned := pixbuf.pixbuf_apply_embedded_orientation(pb)    // EXIF rotation; a new pixbuf, pb is untouched
defer gobj.object_unref(turned)
small := pixbuf.pixbuf_scale_simple(turned, 320, 240, .BILINEAR)   // new; nil when out of memory
if small == nil { return }
defer gobj.object_unref(small)
flipped := pixbuf.pixbuf_flip(small, true)                // also new: _flip, _rotate_simple, _copy, _add_alpha
defer gobj.object_unref(flipped)

w, h: i32
format := pixbuf.pixbuf_get_file_info("photo.jpg", &w, &h)   // reads the header, decodes nothing; borrowed, nil if unknown
if format != nil { _ = pixbuf.pixbuf_format_get_name(format) }   // "jpeg", "png"
fitted := pixbuf.pixbuf_new_from_file_at_size("photo.jpg", 256, 256, &gerr)   // decoded small: far cheaper for a thumbnail
if fitted != nil { gobj.object_unref(fitted) }

keys := [?]cstring{"quality", nil}                        // option keys and values: nil-terminated arrays
vals := [?]cstring{"90", nil}
if !pixbuf.pixbuf_savev(small, "out.jpg", "jpeg", &keys[0], &vals[0], &gerr) {
	glib.error_free(gerr)
}
buf: [^]u8
size: glib.size
if pixbuf.pixbuf_save_to_bufferv(small, &buf, &size, "png", nil, nil, &gerr) {   // PNG in memory, no options
	glib.free(buf)                                        // the buffer is g_malloc'd
}
```

| remember | |
|---|---|
| Everything `_new*`, `_scale_simple`, `_flip`, `_rotate_simple`, `_apply_embedded_orientation` returns is yours | one `gobj.object_unref` each; the input is never consumed, so unref it too |
| A failed call sets the error only if you passed one | pass `&gerr`, free it with `glib.error_free`; nil is allowed when you do not care |
| `pixbuf_get_file_info` before a full decode | gives the size and format from the header; the `PixbufFormat` is borrowed, never freed |
| Decode small when you only need small | `_new_from_file_at_size` and the loader's `set_size` let a JPEG decode at a reduced scale |
| Save keys and values are two nil-terminated arrays | `"quality"` for JPEG, `"compression"` for PNG; values are strings |

## pixbuf:gdkpixbuf — pixels

```odin
import "cairo:cairo"
import gobj "glib:gobject"
import pixbuf "pixbuf:gdkpixbuf"

pb := pixbuf.pixbuf_new(.RGB, true, 8, 64, 64)            // colorspace, alpha, bits per sample, width, height
defer gobj.object_unref(pb)                               // the pixels are uninitialised
pixbuf.pixbuf_fill(pb, 0x336699ff)                        // 0xRRGGBBAA

px := pixbuf.pixbuf_get_pixels(pb)                        // [^]u8: index it directly
stride := int(pixbuf.pixbuf_get_rowstride(pb))            // bytes per row: not width * channels
n := int(pixbuf.pixbuf_get_n_channels(pb))                // 3, or 4 with alpha
x, y := 10, 20
i := y * stride + x * n
r, g, b := px[i], px[i + 1], px[i + 2]                    // bytes are R G B (A): straight, not premultiplied
if pixbuf.pixbuf_get_has_alpha(pb) { px[i + 3] = 255 }
px[i], px[i + 1], px[i + 2] = b, g, r

part := pixbuf.pixbuf_new_subpixbuf(pb, 8, 8, 16, 16)     // shares the parent's pixels and keeps it alive
defer gobj.object_unref(part)
own := pixbuf.pixbuf_copy(pb)                             // an independent copy
defer gobj.object_unref(own)

// To cairo: straight RGBA bytes to premultiplied B G R A, row by row.
surf := cairo.image_surface_create(.ARGB32, 64, 64)
defer cairo.surface_destroy(surf)
dst := cairo.image_surface_get_data(surf)
dstride := int(cairo.image_surface_get_stride(surf))
cairo.surface_flush(surf)
for row in 0 ..< 64 {
	for col in 0 ..< 64 {
		s, d := row * stride + col * n, row * dstride + col * 4
		a := u32(px[s + 3]) if n == 4 else 255
		dst[d + 0] = u8(u32(px[s + 2]) * a / 255)         // B
		dst[d + 1] = u8(u32(px[s + 1]) * a / 255)         // G
		dst[d + 2] = u8(u32(px[s + 0]) * a / 255)         // R
		dst[d + 3] = u8(a)
	}
}
cairo.surface_mark_dirty(surf)
```

| remember | |
|---|---|
| `pixbuf_get_pixels` returns `[^]u8` | index it with the rowstride; the pointer is borrowed and valid while the pixbuf lives |
| Use the rowstride | rows are padded, and the last row may be shorter; never assume `width * channels` |
| The format is fixed | 8 bits per sample, RGB with an optional alpha, bytes in R G B A order; alpha is straight |
| Cairo is the other way round | `ARGB32` is premultiplied and little-endian B G R A; no call here converts, so loop as above |
| A subpixbuf shares memory | writing to it writes to the parent; `pixbuf_copy` first when that is not wanted |
| `pixbuf_new` does not clear | `pixbuf_fill` before reading |

## pixbuf:gdkpixbuf — streams and animation

```odin
import glib "glib:glib"
import gobj "glib:gobject"
import pixbuf "pixbuf:gdkpixbuf"

data := []u8{}                                            // a stream's bytes, in chunks if you like
gerr: ^glib.Error
ldr := pixbuf.pixbuf_loader_new()                         // or _new_with_type("png", &gerr) to skip sniffing
defer gobj.object_unref(ldr)
pixbuf.pixbuf_loader_set_size(ldr, 640, 480)              // before the first write: decode scaled down

fed := pixbuf.pixbuf_loader_write(ldr, raw_data(data), glib.size(len(data)), &gerr)
if !fed { glib.error_free(gerr); gerr = nil }
closed := pixbuf.pixbuf_loader_close(ldr, &gerr)          // always: an unclosed loader warns at finalize
if !closed { glib.error_free(gerr) }

frame := pixbuf.pixbuf_loader_get_pixbuf(ldr)             // borrowed: the loader owns it
if frame != nil {
	kept := (^pixbuf.Pixbuf)(gobj.object_ref(frame))      // take your own reference to outlive the loader
	gobj.object_unref(kept)
}

anim := pixbuf.pixbuf_loader_get_animation(ldr)           // borrowed as well
if anim != nil && !pixbuf.pixbuf_animation_is_static_image(anim) {
	it := pixbuf.pixbuf_animation_get_iter(anim, nil)     // nil start time is now
	defer gobj.object_unref(it)
	img := pixbuf.pixbuf_animation_iter_get_pixbuf(it)    // borrowed, valid until the next advance
	delay := pixbuf.pixbuf_animation_iter_get_delay_time(it)   // milliseconds; -1 shows this frame for good
	if delay >= 0 {
		// from a timer, delay ms later:
		pixbuf.pixbuf_animation_iter_advance(it, nil)     // true when the picture changed
	}
	_ = img
}
```

| remember | |
|---|---|
| `pixbuf_loader_get_pixbuf` and `_get_animation` are borrowed | `gobj.object_ref` before unreffing the loader, then unref your reference |
| Close the loader | after the last write, and after a failed one; `close` returns the error for a truncated image |
| `iter_get_pixbuf` is valid until the next `advance` | draw or copy it first; unref nothing |
| Delay is milliseconds, -1 means show this frame for good | stop advancing there |
| `^glib.uchar` buffers take `raw_data(slice)` | and `glib.size(len(slice))` for the count |
