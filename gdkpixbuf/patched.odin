package gdkpixbuf

import glib "glib:glib"

// One typed pin per hand fix listed in docs/PATCHED.md: a regeneration that drops a fix
// fails to compile here.

// Byte buffers are multi-pointers, not pointers to one byte (`guchar *` in C).
@(private)
_pin_pixbuf_get_pixels: proc "c" (pixbuf: ^Pixbuf) -> [^]u8 = pixbuf_get_pixels

@(private)
_pin_pixbuf_get_pixels_with_length: proc "c" (pixbuf: ^Pixbuf, length: ^glib.uint_) -> [^]u8 = pixbuf_get_pixels_with_length

@(private)
_pin_pixbuf_read_pixels: proc "c" (pixbuf: ^Pixbuf) -> [^]u8 = pixbuf_read_pixels

@(private)
_pin_pixbuf_new_from_data: proc "c" (data: [^]u8, colorspace: Colorspace, has_alpha: glib.boolean, bits_per_sample: i32, width: i32, height: i32, rowstride: i32, destroy_fn: PixbufDestroyNotify, destroy_fn_data: glib.pointer) -> ^Pixbuf = pixbuf_new_from_data

@(private)
_pin_pixbuf_new_from_inline: proc "c" (data_length: glib.int_, data: [^]u8, copy_pixels: glib.boolean, error: ^^glib.Error) -> ^Pixbuf = pixbuf_new_from_inline

@(private)
_pin_pixbuf_loader_write: proc "c" (loader: ^PixbufLoader, buf: [^]u8, count: glib.size, error: ^^glib.Error) -> glib.boolean = pixbuf_loader_write

@(private)
_pin_pixbuf_save_to_bufferv: proc "c" (pixbuf: ^Pixbuf, buffer: ^[^]u8, buffer_size: ^glib.size, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, error: ^^glib.Error) -> glib.boolean = pixbuf_save_to_bufferv

@(private)
_pin_pixbuf_save_to_buffer: proc "c" (pixbuf: ^Pixbuf, buffer: ^[^]u8, buffer_size: ^glib.size, type: cstring, error: ^^glib.Error, #c_vararg var_args: ..any) -> glib.boolean = pixbuf_save_to_buffer

@(private)
_pin_destroy_notify: PixbufDestroyNotify = proc "c" (pixels: [^]u8, data: glib.pointer) {}

@(private)
_pin_save_func: PixbufSaveFunc = proc "c" (buf: [^]u8, count: glib.size, error: ^^glib.Error, data: glib.pointer) -> glib.boolean {
    return true
}
