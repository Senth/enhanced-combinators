require("util")
require("circuit-connector-sprites")

function generate_enhanced_output_combinator(combinator)
    return combinator
end

function generate_enhanced_combinator_1(combinator)
    generate_enhanced_combinator(combinator, 1, 250, "5KW")
    return combinator
end

function generate_enhanced_combinator_2(combinator)
    generate_enhanced_combinator(combinator, 2, 350, "25KW")
    return combinator
end

function generate_enhanced_combinator_3(combinator)
    generate_enhanced_combinator(combinator, 3, 500, "125KW")
    return combinator
end

function generate_enhanced_output_combinator_1(combinator)
    generate_enhanced_output_combinator(combinator, 1, 250, 20)
    return combinator
end

function generate_enhanced_output_combinator_2(combinator)
    generate_enhanced_output_combinator(combinator, 2, 350, 50)
    return combinator
end

function generate_enhanced_output_combinator_3(combinator)
    generate_enhanced_output_combinator(combinator, 3, 500, 200)
    return combinator
end

--- Generates an enhanced combinator with all variables changed
--- @param combinator the combinator to set
--- @param version the integer that the combinator name ends with
--- @param health health of the combinator
--- @param energy amount of energy the combinator uses
function generate_enhanced_combinator(combinator, version, health, energy)
    combinator.type = "arithmetic-combinator"
    combinator.name = "enhanced-combinator-" .. version
    combinator.icon = "__enhanced-combinators__/graphics/icons/enhanced-combinator-" .. version .. ".png"
    combinator.icon_size = 32
    combinator.flags = {
        "placeable-neutral",
        "player-creation"
    }
    combinator.minable = {
        hardness = 0.2,
        mining_time = 0.5,
        result = "enhanced-combinator-" .. version,
    }
    combinator.max_health = health
    combinator.corpse = "small-remnants"
    combinator.collision_box = { { -0.35, -0.65 }, { 0.35, 0.65 } }
    combinator.selection_box = { { -0.5, 0 }, { 0.5, 1 } }
    combinator.energy_source = {
        type = "electric",
        usage_priority = "secondary-input"
    }
    combinator.item_slot_count = 12
    combinator.active_energy_usage = energy
    combinator.working_sound = {
        sound = {
            filename = "__base__/sound/combinator.ogg",
            volume = 0.35,
        },
        max_sounds_per_type = 2,
        match_speed_to_activity = true,
    }
    combinator.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
    combinator.activity_led_light = {
        intensity = 0.8,
        size = 1,
        color = { r = 1.0, g = 1.0, b = 1.0 },
    }
    combinator.activity_led_light_offsets = {
        { 0.265625, -0.53125 },
        { 0.515625, -0.078125 },
        { -0.25, 0.03125 },
        { -0.46875, -0.5 }
    }
    combinator.screen_light = {
        intensity = 0.3,
        size = 0.6,
        color = { r = 1.0, g = 1.0, b = 1.0 },
    }
    combinator.screen_light_offsets =
    {
        { 0.015625, -0.265625 },
        { 0.015625, -0.359375 },
        { 0.015625, -0.265625 },
        { 0.015625, -0.359375 }
    }
    combinator.input_connection_bounding_box = { { -0.5, 0 }, { 0.5, 1 } }
    combinator.output_connection_bounding_box = { { -0.5, -1 }, { 0.5, 0 } }
    combinator.circuit_wire_max_distance = 9

    -- SPRITES
    local default_display_sprite = {
        north =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            y = 22 * (version - 1),
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        east =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            y = 22 * (version - 1),
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
        south =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            y = 22 * (version - 1),
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -4.5),
        },
        west =
        {
            scale = 0.5,
            filename = "__enhanced-combinators__/graphics/entity/hr-enhanced-combinator-displays.png",
            x = 30,
            y = 22 * (version - 1),
            width = 30,
            height = 22,
            shift = util.by_pixel(0, -10.5),
        },
    }

    combinator.sprites = make_4way_animation_from_spritesheet({
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
    -- Timer
    combinator.left_shift_symbol_sprites =
    {
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
    -- Min
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
    -- Max
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
    -- TODO Sort
    combinator.divide_symbol_sprites = default_display_sprite
    -- TODO Average
    combinator.modulo_symbol_sprites = default_display_sprite
    -- TODO Memory
    combinator.power_symbol_sprites = default_display_sprite

    -- Set the others sprites to default E
    combinator.multiply_symbol_sprites = default_display_sprite
    combinator.right_shift_symbol_sprites = default_display_sprite
    combinator.and_symbol_sprites = default_display_sprite
    combinator.or_symbol_sprites = default_display_sprite
    combinator.xor_symbol_sprites = default_display_sprite

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
end

function generate_enhanced_output_combinator(combinator, version, health, output_slots)
    combinator.type = "constant-combinator"
    combinator.name = "enhanced-output-combinator-" .. version
    combinator.icon = "__enhanced-combinators__/graphics/icons/enhanced-combinator-" .. version .. ".png"
    combinator.icon_size = 32
    combinator.flags = { "placeable-neutral", "player-creation" }
    combinator.minable = { hardness = 0.2, mining_time = 0.5, result = "enhanced-combinator-" .. version }
    combinator.max_health = health
    combinator.corpse = "small-remnants"
    combinator.collision_box = { { -0.05, -0.05 }, { 0.05, 0.05 } }
    combinator.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    combinator.item_slot_count = output_slots
    combinator.vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 }
    combinator.activity_led_light =
    {
        intensity = 0,
        size = 1,
        color = { r = 1.0, g = 1.0, b = 1.0 }
    }
    combinator.activity_led_light_offsets =
    {
        { 0.296875, -0.40625 },
        { 0.25, -0.03125 },
        { -0.296875, -0.078125 },
        { -0.21875, -0.46875 }
    }
    combinator.circuit_wire_max_distance = 9
    -- TODO use enhanced combinator image so that the entity-preview works correctly
    combinator.sprites = make_4way_animation_from_spritesheet({
        layers =
        {
            {
                filename = "__enhanced-combinators__/graphics/entity/invisible-entity.png",
                width = 1,
                height = 1,
                frame_count = 1,
            },
        },
    })
    combinator.activity_led_sprites = {
        north =
        {
            filename = "__enhanced-combinators__/graphics/entity/invisible-entity.png",
            width = 1,
            height = 1,
            frame_count = 1,
        },
        east =
        {
            filename = "__enhanced-combinators__/graphics/entity/invisible-entity.png",
            width = 1,
            height = 1,
            frame_count = 1,
        },
        south =
        {
            filename = "__enhanced-combinators__/graphics/entity/invisible-entity.png",
            width = 1,
            height = 1,
            frame_count = 1,
        },
        west =
        {
            filename = "__enhanced-combinators__/graphics/entity/invisible-entity.png",
            width = 1,
            height = 1,
            frame_count = 1,
        },
    }
    combinator.circuit_wire_connection_points = {
        -- North
        {
            shadow =
            {
                red = util.by_pixel(4, 6.5),
                green = util.by_pixel(23.5, 7),
            },
            wire =
            {
                red = util.by_pixel(-9, -3),
                green = util.by_pixel(10, -3),
            },
        },
        -- East
        {
            shadow =
            {
                red = util.by_pixel(21.5, 0.5),
                green = util.by_pixel(21, 14),
            },
            wire =
            {
                red = util.by_pixel(7, -11),
                green = util.by_pixel(7, 3),
            },
        },
        -- South
        {
            shadow =
            {
                red = util.by_pixel(23, 12.5),
                green = util.by_pixel(3, 13),
            },
            wire =
            {
                red = util.by_pixel(9, 0.5),
                green = util.by_pixel(-10, 0.5),
            },
        },
        -- West
        {
            shadow =
            {
                red = util.by_pixel(9.5, 14),
                green = util.by_pixel(9, 0),
            },
            wire =
            {
                red = util.by_pixel(-6, 2.5),
                green = util.by_pixel(-6, -10.5),
            },
        },
    }
end

data:extend({
    generate_enhanced_combinator_1 {},
    generate_enhanced_combinator_2 {},
    generate_enhanced_combinator_3 {},

    -- Invisible output combinator to allow outputting lots of signals from a regular arithmetic combinator
    generate_enhanced_output_combinator_1 {},
    generate_enhanced_output_combinator_2 {},
    generate_enhanced_output_combinator_3 {},
})