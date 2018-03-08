require "common.class"
require "enhanced_combinator"

-- Min Max Combinator which inherits from Enhanced Combinator
MinMaxCombinator = class(EnhancedCombinator, function(combinator, entity)
    EnhancedCombinator.init(combinator, entity)
    combinator.type = "MIN"
    combinator.filter = {}
end)

function MinMaxCombinator.is_instance(entity)
    if entity ~= nil then
        return entity.name == MinMaxCombinator.get_name()
    else
        return false
    end
end

function MinMaxCombinator.get_name()
    return "enhanced-combinator-min-max"
end

function MinMaxCombinator:on_gui_opened(player)
    local frame = EnhancedCombinator.gui_create_frame(player, {"enhanced-combinator-min-max-caption"})
    frame.add({type = "label", name = "test_label", caption = "This is a test label"})

    player.opened = nil
end