function generate_enhanced_combinator_1(combinator)
    combinator.sprites = make_4way_animation_from_spritesheet({
        layers = {
            {
                scale = 0.5,
                filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-1.png",
                width = 144,
                height = 124,
                frame_count = 1,
                shift = util.by_pixel(0.5, 7.5),
            },
            {
                scale = 0.5,
                filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-shadow.png",
                width = 148,
                height = 156,
                frame_count = 1,
                shift = util.by_pixel(13.5, 24.5),
                draw_as_shadow = true,
            },
        },
    })
    combinator.activity_led_sprites =
    {
        north =
        {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-arithmetic-combinator-LED-N.png",
            width = 16,
            height = 14,
            frame_count = 1,
            shift = util.by_pixel(8.5, -12.5),
        },
        east =
        {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-arithmetic-combinator-LED-E.png",
            width = 14,
            height = 14,
            frame_count = 1,
            shift = util.by_pixel(16.5, -1),
        },
        south =
        {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-arithmetic-combinator-LED-S.png",
            width = 16,
            height = 16,
            frame_count = 1,
            shift = util.by_pixel(-8, 7.5),
        },
        west =
        {
            scale = 0.5,
            filename = "__base__/graphics/entity/combinator/activity-leds/hr-arithmetic-combinator-LED-W.png",
            width = 14,
            height = 14,
            frame_count = 1,
            shift = util.by_pixel(-16, -12.5),
        },
    }
    combinator.plus_symbol_sprites =
    {
        north =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 90,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        east =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 90,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
        south =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 90,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        west =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 90,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
    }
    combinator.minus_symbol_sprites =
    {
        north =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 60,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        east =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 60,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
        south =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 60,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        west =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 60,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
    }
    local default_sprite = {
        north =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        east =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
        south =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        west =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
    }

    -- Set the others sprites to default M
    combinator.multiply_symbol_sprites = default_sprite
    combinator.divide_symbol_sprites = default_sprite
    combinator.modulo_symbol_sprites = default_sprite
    combinator.power_symbol_sprites = default_sprite
    combinator.left_shift_symbol_sprites = default_sprite
    combinator.right_shift_symbol_sprites = default_sprite
    combinator.and_symbol_sprites = default_sprite
    combinator.or_symbol_sprites = default_sprite
    combinator.xor_symbol_sprites = default_sprite

    -- Input & Output connections
    combinator.input_connection_points =
    {
        {
            shadow =
            {
                red = util.by_pixel(5, 26),
                green = util.by_pixel(24.5, 26),
            },
            wire =
            {
                red = util.by_pixel(-8.5, 14),
                green = util.by_pixel(10, 14),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(-10, -3.5),
                green = util.by_pixel(-10, 9.5),
            },
            wire =
            {
                red = util.by_pixel(-25.5, -15),
                green = util.by_pixel(-25.5, -1.5),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(24.5, -11.5),
                green = util.by_pixel(5.5, -9.5),
            },
            wire =
            {
                red = util.by_pixel(9.5, -21.5),
                green = util.by_pixel(-9, -21.5),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(44, 12),
                green = util.by_pixel(44, -1.5),
            },
            wire =
            {
                red = util.by_pixel(26, -1),
                green = util.by_pixel(26, -14.5),
            },
        },
    }
    combinator.output_connection_points =
    {
        {
            shadow =
            {
                red = util.by_pixel(4, -12.5),
                green = util.by_pixel(23.5, -12),
            },
            wire =
            {
                red = util.by_pixel(-9, -22),
                green = util.by_pixel(10, -22),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(38.5, -1.5),
                green = util.by_pixel(38, 12),
            },
            wire =
            {
                red = util.by_pixel(23, -13),
                green = util.by_pixel(23, 1),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(24, 26.5),
                green = util.by_pixel(4, 27),
            },
            wire =
            {
                red = util.by_pixel(10, 15.5),
                green = util.by_pixel(-9, 15.5),
            },
        },
        {
            shadow =
            {
                red = util.by_pixel(-7, 12.5),
                green = util.by_pixel(-7.5, -1.5),
            },
            wire =
            {
                red = util.by_pixel(-22.5, 1),
                green = util.by_pixel(-22.5, -12),
            },
        },
    }
    return combinator
end