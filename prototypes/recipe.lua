data:extend({
    {
        type = "recipe",
        name = "enhanced-combinator-1",
        energy_required = 5,
        enabled = false,
        ingredients = {
            {"decider-combinator", 5},
        },
        result = "enhanced-combinator-1",
    },
    {
        type = "recipe",
        name = "enhanced-combinator-2",
        energy_required = 5,
        enabled = false,
        ingredients = {
            {"enhanced-combinator-1", 5},
            {"advanced-circuit", 5},
        },
        result = "enhanced-combinator-2",
    },
    {
        type = "recipe",
        name = "enhanced-combinator-3",
        energy_required = 5,
        enabled = false,
        ingredients = {
            {"enhanced-combinator-2", 5},
            {"processing-unit", 5}
        },
        result = "enhanced-combinator-3",
    }
})