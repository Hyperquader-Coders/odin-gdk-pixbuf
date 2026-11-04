# odin-gdk-pixbuf API

Every public declaration of every package, generated from the source by `make api`; do not
edit. The reference is the [README](../README.md); the short form is the
[cheat sheet](CHEATSHEET.md).

## gdkpixbuf

```text
package gdkpixbuf
	constants
		MAJOR :: 2
		MICRO :: 10
		MINOR :: 42

	variables
		pixbuf_major_version: glib.uint_
		pixbuf_micro_version: glib.uint_
		pixbuf_minor_version: glib.uint_
		pixbuf_version: cstring

	procedures
		colorspace_get_type :: proc() -> gobj.Type ---
		colorspace_get_type :: proc() -> gobj.Type ---
		interp_type_get_type :: proc() -> gobj.Type ---
		interp_type_get_type :: proc() -> gobj.Type ---
		pixbuf_add_alpha :: proc(pixbuf: ^Pixbuf, substitute_color: glib.boolean, r: glib.uchar, g: glib.uchar, b: glib.uchar) -> ^Pixbuf ---
		pixbuf_alpha_mode_get_type :: proc() -> gobj.Type ---
		pixbuf_alpha_mode_get_type :: proc() -> gobj.Type ---
		pixbuf_animation_get_height :: proc(animation: ^PixbufAnimation) -> i32 ---
		pixbuf_animation_get_iter :: proc(animation: ^PixbufAnimation, start_time: ^glib.TimeVal) -> ^PixbufAnimationIter ---
		pixbuf_animation_get_static_image :: proc(animation: ^PixbufAnimation) -> ^Pixbuf ---
		pixbuf_animation_get_type :: proc() -> gobj.Type ---
		pixbuf_animation_get_type :: proc() -> gobj.Type ---
		pixbuf_animation_get_width :: proc(animation: ^PixbufAnimation) -> i32 ---
		pixbuf_animation_is_static_image :: proc(animation: ^PixbufAnimation) -> glib.boolean ---
		pixbuf_animation_iter_advance :: proc(iter: ^PixbufAnimationIter, current_time: ^glib.TimeVal) -> glib.boolean ---
		pixbuf_animation_iter_get_delay_time :: proc(iter: ^PixbufAnimationIter) -> i32 ---
		pixbuf_animation_iter_get_pixbuf :: proc(iter: ^PixbufAnimationIter) -> ^Pixbuf ---
		pixbuf_animation_iter_get_type :: proc() -> gobj.Type ---
		pixbuf_animation_iter_get_type :: proc() -> gobj.Type ---
		pixbuf_animation_iter_on_currently_loading_frame :: proc(iter: ^PixbufAnimationIter) -> glib.boolean ---
		pixbuf_animation_new_from_file :: proc(filename: cstring, error: ^^glib.Error) -> ^PixbufAnimation ---
		pixbuf_animation_new_from_resource :: proc(resource_path: cstring, error: ^^glib.Error) -> ^PixbufAnimation ---
		pixbuf_animation_new_from_stream :: proc(stream: ^gio.InputStream, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^PixbufAnimation ---
		pixbuf_animation_new_from_stream_async :: proc(stream: ^gio.InputStream, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pixbuf_animation_new_from_stream_finish :: proc(async_result: ^gio.AsyncResult, error: ^^glib.Error) -> ^PixbufAnimation ---
		pixbuf_animation_ref :: proc(animation: ^PixbufAnimation) -> ^PixbufAnimation ---
		pixbuf_animation_unref :: proc(animation: ^PixbufAnimation) ---
		pixbuf_apply_embedded_orientation :: proc(src: ^Pixbuf) -> ^Pixbuf ---
		pixbuf_calculate_rowstride :: proc(colorspace: Colorspace, has_alpha: glib.boolean, bits_per_sample: i32, width: i32, height: i32) -> glib.int_ ---
		pixbuf_composite :: proc(src: ^Pixbuf, dest: ^Pixbuf, dest_x: i32, dest_y: i32, dest_width: i32, dest_height: i32, offset_x: f64, offset_y: f64, scale_x: f64, scale_y: f64, interp_type: InterpType, overall_alpha: i32) ---
		pixbuf_composite_color :: proc(src: ^Pixbuf, dest: ^Pixbuf, dest_x: i32, dest_y: i32, dest_width: i32, dest_height: i32, offset_x: f64, offset_y: f64, scale_x: f64, scale_y: f64, interp_type: InterpType, overall_alpha: i32, check_x: i32, check_y: i32, check_size: i32, color1: glib.uint32, color2: glib.uint32) ---
		pixbuf_composite_color_simple :: proc(src: ^Pixbuf, dest_width: i32, dest_height: i32, interp_type: InterpType, overall_alpha: i32, check_size: i32, color1: glib.uint32, color2: glib.uint32) -> ^Pixbuf ---
		pixbuf_copy :: proc(pixbuf: ^Pixbuf) -> ^Pixbuf ---
		pixbuf_copy_area :: proc(src_pixbuf: ^Pixbuf, src_x: i32, src_y: i32, width: i32, height: i32, dest_pixbuf: ^Pixbuf, dest_x: i32, dest_y: i32) ---
		pixbuf_copy_options :: proc(src_pixbuf: ^Pixbuf, dest_pixbuf: ^Pixbuf) -> glib.boolean ---
		pixbuf_error_get_type :: proc() -> gobj.Type ---
		pixbuf_error_get_type :: proc() -> gobj.Type ---
		pixbuf_error_quark :: proc() -> glib.Quark ---
		pixbuf_error_quark :: proc() -> glib.Quark ---
		pixbuf_fill :: proc(pixbuf: ^Pixbuf, pixel: glib.uint32) ---
		pixbuf_flip :: proc(src: ^Pixbuf, horizontal: glib.boolean) -> ^Pixbuf ---
		pixbuf_format_copy :: proc(format: ^PixbufFormat) -> ^PixbufFormat ---
		pixbuf_format_free :: proc(format: ^PixbufFormat) ---
		pixbuf_format_get_description :: proc(format: ^PixbufFormat) -> cstring ---
		pixbuf_format_get_extensions :: proc(format: ^PixbufFormat) -> [^]cstring ---
		pixbuf_format_get_license :: proc(format: ^PixbufFormat) -> cstring ---
		pixbuf_format_get_mime_types :: proc(format: ^PixbufFormat) -> [^]cstring ---
		pixbuf_format_get_name :: proc(format: ^PixbufFormat) -> cstring ---
		pixbuf_format_get_type :: proc() -> gobj.Type ---
		pixbuf_format_is_disabled :: proc(format: ^PixbufFormat) -> glib.boolean ---
		pixbuf_format_is_save_option_supported :: proc(format: ^PixbufFormat, option_key: cstring) -> glib.boolean ---
		pixbuf_format_is_scalable :: proc(format: ^PixbufFormat) -> glib.boolean ---
		pixbuf_format_is_writable :: proc(format: ^PixbufFormat) -> glib.boolean ---
		pixbuf_format_set_disabled :: proc(format: ^PixbufFormat, disabled: glib.boolean) ---
		pixbuf_get_bits_per_sample :: proc(pixbuf: ^Pixbuf) -> i32 ---
		pixbuf_get_byte_length :: proc(pixbuf: ^Pixbuf) -> glib.size ---
		pixbuf_get_colorspace :: proc(pixbuf: ^Pixbuf) -> Colorspace ---
		pixbuf_get_file_info :: proc(filename: cstring, width: ^glib.int_, height: ^glib.int_) -> ^PixbufFormat ---
		pixbuf_get_file_info_async :: proc(filename: cstring, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pixbuf_get_file_info_finish :: proc(async_result: ^gio.AsyncResult, width: ^glib.int_, height: ^glib.int_, error: ^^glib.Error) -> ^PixbufFormat ---
		pixbuf_get_formats :: proc() -> ^glib.SList ---
		pixbuf_get_has_alpha :: proc(pixbuf: ^Pixbuf) -> glib.boolean ---
		pixbuf_get_height :: proc(pixbuf: ^Pixbuf) -> i32 ---
		pixbuf_get_n_channels :: proc(pixbuf: ^Pixbuf) -> i32 ---
		pixbuf_get_option :: proc(pixbuf: ^Pixbuf, key: cstring) -> cstring ---
		pixbuf_get_options :: proc(pixbuf: ^Pixbuf) -> ^glib.HashTable ---
		pixbuf_get_pixels :: proc(pixbuf: ^Pixbuf) -> [^]u8 ---
		pixbuf_get_pixels_with_length :: proc(pixbuf: ^Pixbuf, length: ^glib.uint_) -> [^]u8 ---
		pixbuf_get_rowstride :: proc(pixbuf: ^Pixbuf) -> i32 ---
		pixbuf_get_type :: proc() -> gobj.Type ---
		pixbuf_get_type :: proc() -> gobj.Type ---
		pixbuf_get_width :: proc(pixbuf: ^Pixbuf) -> i32 ---
		pixbuf_init_modules :: proc(path: cstring, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_loader_close :: proc(loader: ^PixbufLoader, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_loader_get_animation :: proc(loader: ^PixbufLoader) -> ^PixbufAnimation ---
		pixbuf_loader_get_format :: proc(loader: ^PixbufLoader) -> ^PixbufFormat ---
		pixbuf_loader_get_pixbuf :: proc(loader: ^PixbufLoader) -> ^Pixbuf ---
		pixbuf_loader_get_type :: proc() -> gobj.Type ---
		pixbuf_loader_get_type :: proc() -> gobj.Type ---
		pixbuf_loader_new :: proc() -> ^PixbufLoader ---
		pixbuf_loader_new_with_mime_type :: proc(mime_type: cstring, error: ^^glib.Error) -> ^PixbufLoader ---
		pixbuf_loader_new_with_type :: proc(image_type: cstring, error: ^^glib.Error) -> ^PixbufLoader ---
		pixbuf_loader_set_size :: proc(loader: ^PixbufLoader, width: i32, height: i32) ---
		pixbuf_loader_write :: proc(loader: ^PixbufLoader, buf: [^]u8, count: glib.size, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_loader_write_bytes :: proc(loader: ^PixbufLoader, buffer: ^glib.Bytes, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_new :: proc(colorspace: Colorspace, has_alpha: glib.boolean, bits_per_sample: i32, width: i32, height: i32) -> ^Pixbuf ---
		pixbuf_new_from_bytes :: proc(data: ^glib.Bytes, colorspace: Colorspace, has_alpha: glib.boolean, bits_per_sample: i32, width: i32, height: i32, rowstride: i32) -> ^Pixbuf ---
		pixbuf_new_from_data :: proc(data: [^]u8, colorspace: Colorspace, has_alpha: glib.boolean, bits_per_sample: i32, width: i32, height: i32, rowstride: i32, destroy_fn: PixbufDestroyNotify, destroy_fn_data: glib.pointer) -> ^Pixbuf ---
		pixbuf_new_from_file :: proc(filename: cstring, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_file_at_scale :: proc(filename: cstring, width: i32, height: i32, preserve_aspect_ratio: glib.boolean, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_file_at_size :: proc(filename: cstring, width: i32, height: i32, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_inline :: proc(data_length: glib.int_, data: [^]u8, copy_pixels: glib.boolean, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_resource :: proc(resource_path: cstring, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_resource_at_scale :: proc(resource_path: cstring, width: i32, height: i32, preserve_aspect_ratio: glib.boolean, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_stream :: proc(stream: ^gio.InputStream, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_stream_async :: proc(stream: ^gio.InputStream, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pixbuf_new_from_stream_at_scale :: proc(stream: ^gio.InputStream, width: glib.int_, height: glib.int_, preserve_aspect_ratio: glib.boolean, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_stream_at_scale_async :: proc(stream: ^gio.InputStream, width: glib.int_, height: glib.int_, preserve_aspect_ratio: glib.boolean, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pixbuf_new_from_stream_finish :: proc(async_result: ^gio.AsyncResult, error: ^^glib.Error) -> ^Pixbuf ---
		pixbuf_new_from_xpm_data :: proc(data: ^cstring) -> ^Pixbuf ---
		pixbuf_new_subpixbuf :: proc(src_pixbuf: ^Pixbuf, src_x: i32, src_y: i32, width: i32, height: i32) -> ^Pixbuf ---
		pixbuf_read_pixel_bytes :: proc(pixbuf: ^Pixbuf) -> ^glib.Bytes ---
		pixbuf_read_pixels :: proc(pixbuf: ^Pixbuf) -> [^]u8 ---
		pixbuf_ref :: proc(pixbuf: ^Pixbuf) -> ^Pixbuf ---
		pixbuf_remove_option :: proc(pixbuf: ^Pixbuf, key: cstring) -> glib.boolean ---
		pixbuf_rotate_simple :: proc(src: ^Pixbuf, angle: PixbufRotation) -> ^Pixbuf ---
		pixbuf_rotation_get_type :: proc() -> gobj.Type ---
		pixbuf_rotation_get_type :: proc() -> gobj.Type ---
		pixbuf_saturate_and_pixelate :: proc(src: ^Pixbuf, dest: ^Pixbuf, saturation: glib.float, pixelate: glib.boolean) ---
		pixbuf_save :: proc(pixbuf: ^Pixbuf, filename: cstring, type: cstring, error: ^^glib.Error, #c_vararg var_args: ..any) -> glib.boolean ---
		pixbuf_save_to_buffer :: proc(pixbuf: ^Pixbuf, buffer: ^[^]u8, buffer_size: ^glib.size, type: cstring, error: ^^glib.Error, #c_vararg var_args: ..any) -> glib.boolean ---
		pixbuf_save_to_bufferv :: proc(pixbuf: ^Pixbuf, buffer: ^[^]u8, buffer_size: ^glib.size, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_save_to_callback :: proc(pixbuf: ^Pixbuf, save_func: PixbufSaveFunc, user_data: glib.pointer, type: cstring, error: ^^glib.Error, #c_vararg var_args: ..any) -> glib.boolean ---
		pixbuf_save_to_callbackv :: proc(pixbuf: ^Pixbuf, save_func: PixbufSaveFunc, user_data: glib.pointer, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_save_to_stream :: proc(pixbuf: ^Pixbuf, stream: ^gio.OutputStream, type: cstring, cancellable: ^gio.Cancellable, error: ^^glib.Error, #c_vararg var_args: ..any) -> glib.boolean ---
		pixbuf_save_to_stream_async :: proc(pixbuf: ^Pixbuf, stream: ^gio.OutputStream, type: cstring, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer, #c_vararg var_args: ..any) ---
		pixbuf_save_to_stream_finish :: proc(async_result: ^gio.AsyncResult, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_save_to_streamv :: proc(pixbuf: ^Pixbuf, stream: ^gio.OutputStream, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, cancellable: ^gio.Cancellable, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_save_to_streamv_async :: proc(pixbuf: ^Pixbuf, stream: ^gio.OutputStream, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, cancellable: ^gio.Cancellable, callback: gio.AsyncReadyCallback, user_data: glib.pointer) ---
		pixbuf_savev :: proc(pixbuf: ^Pixbuf, filename: cstring, type: cstring, option_keys: [^]cstring, option_values: [^]cstring, error: ^^glib.Error) -> glib.boolean ---
		pixbuf_scale :: proc(src: ^Pixbuf, dest: ^Pixbuf, dest_x: i32, dest_y: i32, dest_width: i32, dest_height: i32, offset_x: f64, offset_y: f64, scale_x: f64, scale_y: f64, interp_type: InterpType) ---
		pixbuf_scale_simple :: proc(src: ^Pixbuf, dest_width: i32, dest_height: i32, interp_type: InterpType) -> ^Pixbuf ---
		pixbuf_set_option :: proc(pixbuf: ^Pixbuf, key: cstring, value: cstring) -> glib.boolean ---
		pixbuf_simple_anim_add_frame :: proc(animation: ^PixbufSimpleAnim, pixbuf: ^Pixbuf) ---
		pixbuf_simple_anim_get_loop :: proc(animation: ^PixbufSimpleAnim) -> glib.boolean ---
		pixbuf_simple_anim_get_type :: proc() -> gobj.Type ---
		pixbuf_simple_anim_get_type :: proc() -> gobj.Type ---
		pixbuf_simple_anim_iter_get_type :: proc() -> gobj.Type ---
		pixbuf_simple_anim_new :: proc(width: glib.int_, height: glib.int_, rate: glib.float) -> ^PixbufSimpleAnim ---
		pixbuf_simple_anim_set_loop :: proc(animation: ^PixbufSimpleAnim, loop: glib.boolean) ---
		pixbuf_unref :: proc(pixbuf: ^Pixbuf) ---

	types
		Colorspace :: enum u32 {RGB = 0}
		InterpType :: enum u32 {NEAREST = 0, TILES = 1, BILINEAR = 2, HYPER = 3}
		Pixbuf :: struct #packed {}
		PixbufAlphaMode :: enum u32 {BILEVEL = 0, FULL = 1}
		PixbufAnimation :: struct #packed {}
		PixbufAnimationIter :: struct #packed {}
		PixbufDestroyNotify :: #type proc(pixels: [^]u8, data: glib.pointer)
		PixbufError :: enum u32 {CORRUPT_IMAGE = 0, INSUFFICIENT_MEMORY = 1, BAD_OPTION = 2, UNKNOWN_TYPE = 3, UNSUPPORTED_OPERATION = 4, FAILED = 5, INCOMPLETE_ANIMATION = 6}
		PixbufFormat :: struct #packed {}
		PixbufLoader :: struct {parent_instance: gobj.Object, priv: glib.pointer}
		PixbufLoaderClass :: struct {parent_class: gobj.ObjectClass, size_prepared: size_prepared_func_ptr_anon_0, area_prepared: area_prepared_func_ptr_anon_1, area_updated: area_updated_func_ptr_anon_2, closed: closed_func_ptr_anon_3}
		PixbufRotation :: enum u32 {NONE = 0, COUNTERCLOCKWISE = 90, UPSIDEDOWN = 180, CLOCKWISE = 270}
		PixbufSaveFunc :: #type proc(buf: [^]u8, count: glib.size, error: ^^glib.Error, data: glib.pointer) -> glib.boolean
		PixbufSimpleAnim :: struct #packed {}
		PixbufSimpleAnimClass :: struct #packed {}
		area_prepared_func_ptr_anon_1 :: #type proc(loader: ^PixbufLoader)
		area_updated_func_ptr_anon_2 :: #type proc(loader: ^PixbufLoader, x: i32, y: i32, width: i32, height: i32)
		closed_func_ptr_anon_3 :: #type proc(loader: ^PixbufLoader)
		size_prepared_func_ptr_anon_0 :: #type proc(loader: ^PixbufLoader, width: i32, height: i32)

	files:
		gdkpixbuf.odin
		patched.odin
```
