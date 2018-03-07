data:extend({
    {
        type = "technology",
        name = "enhanced-combinators-1",
        icon_size = 128,
        icon = "__enhanced-combinators__/graphics/technology/enhanced-combinators-1.png",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "enhanced-combinator-min-max",
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
    }
})