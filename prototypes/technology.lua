data:extend({
    {
        type = "technology",
        name = "enhanced-combinator-1",
        icon_size = 128,
        icon = "__enhanced-combinators__/graphics/technology/enhanced-combinator-1.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "enhanced-combinator-1",
            }
        },
        prerequisites = {"circuit-network"},
        unit = {
            count = 150,
            ingredients = {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
            },
            time = 15,
        },
        order = "a-d-e"
    },
    {
        type = "technology",
        name = "enhanced-combinator-2",
        icon_size = 128,
        icon = "__enhanced-combinators__/graphics/technology/enhanced-combinator-2.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "enhanced-combinator-2",
            }
        },
        prerequisites = {"enhanced-combinator-1", "advanced-electronics"},
        unit = {
            count = 200,
            ingredients = {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
            },
            time = 15,
        },
        order = "a-d-e"
    },
    {
        type = "technology",
        name = "enhanced-combinator-3",
        icon_size = 128,
        icon = "__enhanced-combinators__/graphics/technology/enhanced-combinator-3.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "enhanced-combinator-3",
            }
        },
        prerequisites = {"enhanced-combinator-2", "advanced-electronics-2"},
        unit = {
            count = 300,
            ingredients = {
                {"science-pack-1", 1},
                {"science-pack-2", 1},
                {"science-pack-3", 1},
                {"high-tech-science-pack", 1},
            },
            time = 15,
        },
        order = "a-d-e"
    }
})