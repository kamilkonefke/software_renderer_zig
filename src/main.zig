const std = @import("std");

const c = @cImport({
    @cInclude("SDL3/SDL.h");
});

const WIDTH: i32 = 640;
const HEIGHT: i32 = 360;

fn hex_to_rgb(hex: u24) @Vector(3, u8) {
    const r: u8 = @intCast(hex >> 16 & 0xFF);
    const g: u8 = @intCast(hex >> 8 & 0xFF);
    const b: u8 = @intCast(hex & 0xFF);
    return @Vector(3, u8){r, g, b};
}

fn draw_text(renderer: ?*c.SDL_Renderer, pos: @Vector(2, f32), text: [*c]const u8) void {
    _ = c.SDL_SetRenderScale(renderer, 2.0, 2.0);
    _ = c.SDL_SetRenderDrawColor(renderer, 224, 222, 244, 255);
    _ = c.SDL_RenderDebugText(renderer, pos[0], pos[1], text);
    _ = c.SDL_SetRenderScale(renderer, 1.0, 1.0);
}

fn draw_line(renderer: ?*c.SDL_Renderer, p0: @Vector(2, f32), p1: @Vector(2, f32), color_in_hex: u24) void {
    const color = hex_to_rgb(color_in_hex);
    _ = c.SDL_SetRenderDrawColor(renderer, color[0], color[1], color[2], 255);
    _ = c.SDL_RenderLine(renderer, p0[0], p0[1], p1[0], p1[1]);
}

pub fn main() !void {
    _ = c.SDL_Init(c.SDL_INIT_VIDEO);
    defer c.SDL_Quit();

    const window = c.SDL_CreateWindow("Biszkopt", WIDTH, HEIGHT, 0);
    const renderer = c.SDL_CreateRenderer(window, null);

    var ev: c.SDL_Event = undefined;
    while (true) {
        _ = c.SDL_PollEvent(&ev);
        if (ev.type == c.SDL_EVENT_QUIT) break;

        if (ev.type == c.SDL_EVENT_MOUSE_MOTION) {
            // std.debug.print("{}\n", .{ev.motion.x});
            // std.debug.print("{}\n", .{ev.motion.y});
        }

        _ = c.SDL_SetRenderDrawColor(renderer, 42, 39, 63, 255);
        _ = c.SDL_RenderClear(renderer);

        const pos = @Vector(2, f32){0.0, 0.0};
        draw_text(renderer, pos, "EO");

        draw_line(renderer, @Vector(2, f32){0.0, 0.0}, @Vector(2, f32){128.0, 128.0}, 0xffffff);

        _ = c.SDL_RenderPresent(renderer);
    }
}
