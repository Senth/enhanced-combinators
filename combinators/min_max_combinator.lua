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
    local window = self:create_gui_window(player, { "enhanced-combinator-min-max-name" })

    self:create_gui_min_max_choice(window)
    self:create_gui_filter_table(window)
    self:create_gui_update_interval(window)
end

function MinMaxCombinator:create_gui_min_max_choice(window)
    local choice_frame = window.add({ type = "frame", name = "choice_frame", caption = { "enhanced-combinator-min-max-choice" }, style = "enhanced-combinators-frame" })
    local choice_table = choice_frame.add({ type = "table", name = "choice_table", column_count = 2 })
    choice_table.style.horizontal_spacing = 10

    local min_radio_button = choice_table.add({ type = "radiobutton", name = "min_radio_button", caption = { "enhanced-combinator-min" }, state = true })
    local max_radio_button = choice_table.add({ type = "radiobutton", name = "max_radio_button", caption = { "enhanced-combinator-max" }, state = false })
end

function MinMaxCombinator:create_gui_filter_table(window)
    local filter_frame = window.add({ type = "frame", name = "filter_frame", caption = { "enhanced-combinator-filters" }, style = "enhanced-combinators-frame" })
    local filter_table = filter_frame.add({ type = "table", name = "filter_table", column_count = 5, style = "enhanced-combinators-filter-table" })
    local filters = {}

    for i = 1, 10 do
        local name = "filter" .. i
        local filter = filter_table.add({ type = "choose-elem-button", name = name, elem_type = "signal" })
        table.insert(filters, filter)
    end
end

function MinMaxCombinator:create_gui_update_interval(window)
    local update_interval = window.add({ type = "frame", name = "update_interval", caption = { "enhanced-combinator-update-interval" }, style = "enhanced-combinators-frame" })

--    local update_table = update_interval.add({type = "table", name = "update_table", column_count = 3})

    local every_label = update_interval.add({type = "label", name = "every_label", caption = "Every"})
    local interval_textfield = update_interval.add({type = "textfield", name = "interval_textfield"})
    local tick_label = update_interval.add({type = "label", name = "tick_label", caption = "tick(s)."})
end