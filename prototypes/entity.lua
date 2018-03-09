require("util")
require("circuit-connector-sprites")

function generate_enhanced_combinator_1(combinator)
    combinator = generate_enhanced_combinator_1(1, 250, "5KW")
end

function generate_enhanced_combinator_2(combinator)
    combinator = generate_enhanced_combinator_1(2, 350, "25KW")
end

function generate_enhanced_combinator_3(combinator)
    combinator = generate_enhanced_combinator_1(3, 500, "125KW")
end

--- Generates an enhanced combinator with all variables changed
--- @param version the integer that the combinator name ends with
--- @param health health of the combinator
--- @param energy amount of energy the combinator uses
function generate_enhanced_combinator(version, health, energy)
    local default_display_sprite = {
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

    local enhanced_combinator = {
        type = "arithmetic-combinator",
        name = "enhanced-combinator-" .. version,
        icon = "__enhanced-combinators__/graphics/icons/enhanced-combinator-" .. version .. ".png",
        icon_size = 32,
        flags = {
            "placeable-neutral",
            "player-creation"
        },
        minable = {
            hardness = 0.2,
            mining_time = 0.5,
            result = "enhanced-combinator-" .. version,
        },
        max_health = health,
        corpse = "small-remnants",
        collision_box = { { -0.35, -0.65 }, { 0.35, 0.65 } },
        selection_box = { { -0.5, -1 }, { 0.5, 1 } },
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input"
        },
        item_slot_count = 12,
        active_energy_usage = energy,
        working_sound = {
            sound = {
                filename = "__base__/sound/combinator.ogg",
                volume = 0.35,
            },
            max_sounds_per_type = 2,
            match_speed_to_activity = true,
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        activity_led_light = {
            intensity = 0.8,
            size = 1,
            color = { r = 1.0, g = 1.0, b = 1.0 },
        },
        activity_led_light_offsets = {
            { 0.265625, -0.53125 },
            { 0.515625, -0.078125 },
            { -0.25, 0.03125 },
            { -0.46875, -0.5 }
        },
        screen_light = {
            intensity = 0.3,
            size = 0.6,
            color = { r = 1.0, g = 1.0, b = 1.0 },
        },
        screen_light_offsets =
        {
            { 0.015625, -0.265625 },
            { 0.015625, -0.359375 },
            { 0.015625, -0.265625 },
            { 0.015625, -0.359375 }
        },
        input_connection_bounding_box = { { -0.5, 0 }, { 0.5, 1 } },
        output_connection_bounding_box = { { -0.5, -1 }, { 0.5, 0 } },
        circuit_wire_max_distance = 9,

        -- SPRITES
        sprites = make_4way_animation_from_spritesheet({
            layers = {
                {
                    scale = 0.5,
                    filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-" .. version .. ".png",
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
        }),
        activity_led_sprites =
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
        },
        plus_symbol_sprites =
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
        },
        minus_symbol_sprites =
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
        },

        -- Set the others sprites to default M
        multiply_symbol_sprites = default_display_sprite,
        divide_symbol_sprites = default_display_sprite,
        modulo_symbol_sprites = default_display_sprite,
        power_symbol_sprites = default_display_sprite,
        left_shift_symbol_sprites = default_display_sprite,
        right_shift_symbol_sprites = default_display_sprite,
        and_symbol_sprites = default_display_sprite,
        or_symbol_sprites = default_display_sprite,
        xor_symbol_sprites = default_display_sprite,

        -- Input & Output connections
        input_connection_points =
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
        },
        output_connection_points =
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
    }
    return enhanced_combinator
end

data:extend({
    generate_enhanced_combinator_1,
    generate_enhanced_combinator_2,
    generate_enhanced_combinator_3,
--    generate_enhanced_combinator_1 = generate_enhanced_combinator(1, 250, "5KW"),
--    generate_enhanced_combinator_2 = generate_enhanced_combinator(2, 350, "25KW"),
--    generate_enhanced_combinator_3 = generate_enhanced_combinator(3, 500, "125KW"),
})