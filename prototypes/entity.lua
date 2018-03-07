require("util")
require("enhanced-combinator-pictures")
require("circuit-connector-sprites")

data:extend({
    generate_enhanced_combinator_min_max {
        type = "arithmetic-combinator",
        name = "enhanced-combinator-min-max",
        icon = "__enhanced-combinators__/graphics/icons/enhanced-combinator-min-max.png",
        icon_size = 32,
        flags = {
            "placeable-neutral",
            "player-creation"
        },
        minable = {
            hardness = 0.2,
            mining_time = 0.5,
            result = "enhanced-combinator-min-max",
        },
        max_health = 250,
        corpse = "small-remnants",
        collision_box = { { -0.35, -0.65 }, { 0.35, 0.65 } },
        selection_box = { { -0.5, -1 }, { 0.5, 1 } },
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input"
        },
        item_slot_count = 12,
        active_energy_usage = "5KW",
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
}
})