#+test
package gdkpixbuf

import "core:strings"
import "core:testing"
import glib "glib:glib"
import gobj "glib:gobject"

// Version recorded in README.md: "**Bound version:** X.Y.Z".
README :: #load("../README.md", string)

bound_version :: proc() -> (major, minor, micro: int, ok: bool) {
    marker :: "**Bound version:** "
    readme := README
    i := strings.index(readme, marker)
    if i < 0 do return
    rest := readme[i + len(marker):]
    end := strings.index_any(rest, " \n")
    if end < 0 do return
    parts := strings.split(rest[:end], ".", context.temp_allocator)
    if len(parts) != 3 do return
    nums: [3]int
    for p, n in parts {
        v := 0
        if len(p) == 0 do return
        for c in p {
            if c < '0' || c > '9' do return
            v = v * 10 + int(c - '0')
        }
        nums[n] = v
    }
    return nums[0], nums[1], nums[2], true
}

@(test)
test_readme_version_matches_header_macros :: proc(t: ^testing.T) {
    major, minor, micro, ok := bound_version()
    testing.expect(t, ok, "README.md has no '**Bound version:** X.Y.Z'")
    testing.expect_value(t, major, MAJOR)
    testing.expect_value(t, minor, MINOR)
    testing.expect_value(t, micro, MICRO)
}

@(test)
test_loaded_library_is_not_older_than_the_headers :: proc(t: ^testing.T) {
    testing.expect_value(t, int(pixbuf_major_version), MAJOR)
    testing.expect(t, int(pixbuf_minor_version) >= MINOR, "libgdk_pixbuf is older than the bound headers")
    testing.expect(t, len(string(pixbuf_version)) > 0)
}

@(test)
test_type_names :: proc(t: ^testing.T) {
    testing.expect_value(t, string(gobj.type_name(TYPE_PIXBUF())), "GdkPixbuf")
    testing.expect_value(t, string(gobj.type_name(TYPE_PIXBUF_LOADER())), "GdkPixbufLoader")
    testing.expect_value(t, string(gobj.type_name(TYPE_PIXBUF_ANIMATION())), "GdkPixbufAnimation")
}

@(test)
test_new_pixbuf_reports_its_layout :: proc(t: ^testing.T) {
    pb := pixbuf_new(.RGB, true, 8, 5, 3)
    testing.expect(t, pb != nil)
    defer gobj.object_unref(pb)
    testing.expect_value(t, pixbuf_get_width(pb), 5)
    testing.expect_value(t, pixbuf_get_height(pb), 3)
    testing.expect_value(t, pixbuf_get_n_channels(pb), 4)
    testing.expect_value(t, pixbuf_get_colorspace(pb), Colorspace.RGB)
    testing.expect(t, pixbuf_get_rowstride(pb) >= 5 * 4)
    pixbuf_fill(pb, 0xff8000ff)
    pixels := pixbuf_get_pixels(pb)
    testing.expect(t, pixels != nil)
    testing.expect_value(t, pixels[0], 0xff)
    testing.expect_value(t, pixels[1], 0x80)
    testing.expect_value(t, pixels[2], 0x00)
    testing.expect_value(t, pixels[3], 0xff)
}

@(test)
test_scale_returns_a_new_pixbuf :: proc(t: ^testing.T) {
    pb := pixbuf_new(.RGB, false, 8, 8, 4)
    defer gobj.object_unref(pb)
    scaled := pixbuf_scale_simple(pb, 2, 1, .BILINEAR)
    testing.expect(t, scaled != nil)
    defer gobj.object_unref(scaled)
    testing.expect_value(t, pixbuf_get_width(scaled), 2)
    testing.expect_value(t, pixbuf_get_height(scaled), 1)
}

@(test)
test_png_round_trip_through_the_loader :: proc(t: ^testing.T) {
    pb := pixbuf_new(.RGB, true, 8, 6, 4)
    defer gobj.object_unref(pb)
    pixbuf_fill(pb, 0x336699ff)

    err: ^glib.Error
    buf: [^]u8
    size: glib.size
    ok := pixbuf_save_to_bufferv(pb, &buf, &size, "png", nil, nil, &err)
    testing.expect(t, bool(ok))
    if !ok {
        glib.error_free(err)
        return
    }
    defer glib.free(buf)
    testing.expect(t, size > 8)
    png_magic := [?]u8{0x89, 'P', 'N', 'G'}
    for b, i in png_magic do testing.expect_value(t, buf[i], b)

    loader := pixbuf_loader_new()
    defer gobj.object_unref(loader)
    testing.expect(t, bool(pixbuf_loader_write(loader, buf, size, &err)))
    testing.expect(t, bool(pixbuf_loader_close(loader, &err)))
    got := pixbuf_loader_get_pixbuf(loader)
    testing.expect(t, got != nil)
    testing.expect_value(t, pixbuf_get_width(got), 6)
    testing.expect_value(t, pixbuf_get_height(got), 4)
    // PNG is lossless: the decoded pixels are the filled ones.
    gp := pixbuf_get_pixels(got)
    stride := int(pixbuf_get_rowstride(got))
    n := int(pixbuf_get_n_channels(got))
    testing.expect_value(t, gp[3 * stride + 5 * n], 0x33)
    testing.expect_value(t, gp[3 * stride + 5 * n + 1], 0x66)
    testing.expect_value(t, gp[3 * stride + 5 * n + 2], 0x99)
    testing.expect_value(t, gp[3 * stride + 5 * n + 3], 0xff)
    format := pixbuf_loader_get_format(loader)
    testing.expect(t, format != nil)
    testing.expect_value(t, string(pixbuf_format_get_name(format)), "png")
}

@(test)
test_pixels_index_by_rowstride_and_channels :: proc(t: ^testing.T) {
    for has_alpha in ([2]bool{false, true}) {
        pb := pixbuf_new(.RGB, glib.boolean(has_alpha), 8, 7, 5)
        defer gobj.object_unref(pb)
        n := int(pixbuf_get_n_channels(pb))
        stride := int(pixbuf_get_rowstride(pb))
        testing.expect_value(t, n, 4 if has_alpha else 3)
        testing.expect(t, stride >= 7 * n)
        pixels := pixbuf_get_pixels(pb)
        for y in 0 ..< 5 {
            for x in 0 ..< 7 {
                i := y * stride + x * n
                pixels[i], pixels[i + 1], pixels[i + 2] = u8(x), u8(y), u8(x + y)
            }
        }
        for y in 0 ..< 5 {
            for x in 0 ..< 7 {
                i := y * stride + x * n
                testing.expect_value(t, pixels[i], u8(x))
                testing.expect_value(t, pixels[i + 1], u8(y))
                testing.expect_value(t, pixels[i + 2], u8(x + y))
            }
        }
        // The with-length variant and the read-only view see the same bytes.
        length: glib.uint_
        again := pixbuf_get_pixels_with_length(pb, &length)
        testing.expect(t, again == pixels)
        testing.expect_value(t, int(length), int(pixbuf_get_byte_length(pb)))
        testing.expect(t, pixbuf_read_pixels(pb) == pixels)
        testing.expect_value(t, pixbuf_read_pixels(pb)[stride + n + 1], u8(1))
    }
}

@(test)
test_caller_owned_buffer_backs_a_pixbuf :: proc(t: ^testing.T) {
    data: [4 * 3 * 3]u8 // 4 x 3, RGB, rowstride 12
    for &b, i in data do b = u8(i)
    pb := pixbuf_new_from_data(raw_data(data[:]), .RGB, false, 8, 4, 3, 12, nil, nil)
    testing.expect(t, pb != nil)
    defer gobj.object_unref(pb)
    pixels := pixbuf_get_pixels(pb)
    testing.expect(t, pixels == raw_data(data[:]))
    testing.expect_value(t, pixels[12 + 3 + 2], u8(17))
    pixels[0] = 200
    testing.expect_value(t, data[0], u8(200))
}

@(test)
test_loader_rejects_garbage :: proc(t: ^testing.T) {
    loader := pixbuf_loader_new()
    defer gobj.object_unref(loader)
    junk := [?]byte{1, 2, 3, 4, 5, 6, 7, 8}
    err: ^glib.Error
    // The loader sniffs the type from the first bytes it has buffered, so the write itself
    // succeeds; close is where the unknown type is reported.
    pixbuf_loader_write(loader, raw_data(junk[:]), len(junk), nil)
    ok := pixbuf_loader_close(loader, &err)
    testing.expect(t, !bool(ok))
    testing.expect(t, err != nil)
    if err != nil {
        testing.expect_value(t, err.domain, pixbuf_error_quark())
        glib.error_free(err)
    }
}

@(test)
test_formats_include_png :: proc(t: ^testing.T) {
    formats := pixbuf_get_formats()
    defer glib.slist_free(formats)
    found := false
    for l := formats; l != nil; l = l.next {
        f := (^PixbufFormat)(l.data)
        name := pixbuf_format_get_name(f)
        if string(name) == "png" do found = true
        glib.free(rawptr(name))
    }
    testing.expect(t, found, "no png loader installed")
}

@(test)
test_simple_animation_iterates_frames :: proc(t: ^testing.T) {
    anim := pixbuf_simple_anim_new(4, 4, 10)
    defer gobj.object_unref(anim)
    for _ in 0 ..< 3 {
        frame := pixbuf_new(.RGB, true, 8, 4, 4)
        pixbuf_simple_anim_add_frame(anim, frame)
        gobj.object_unref(frame)
    }
    base := (^PixbufAnimation)(anim)
    testing.expect_value(t, pixbuf_animation_get_width(base), 4)
    testing.expect_value(t, pixbuf_animation_get_height(base), 4)
    testing.expect(t, !bool(pixbuf_animation_is_static_image(base)))
    iter := pixbuf_animation_get_iter(base, nil)
    testing.expect(t, iter != nil)
    defer gobj.object_unref(iter)
    testing.expect(t, pixbuf_animation_iter_get_pixbuf(iter) != nil)
    testing.expect_value(t, pixbuf_animation_iter_get_delay_time(iter), 100)
}
