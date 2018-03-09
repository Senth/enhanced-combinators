require "common.class"
require "common.debug"
require "common.string"

local GUI_NAME = "enhanced-combinator-gui"

ENHANCED_COMBINATOR_TYPES_MIN = "MIN"
ENHANCED_COMBINATOR_TYPES_MAX = "MAX"
--ENHANCED_COMBINATOR_TYPES_ORDER = "ORDER"
--ENHANCED_COMBINATOR_TYPES_AVERAGE = "AVERAGE"
--ENHANCED_COMBINATOR_TYPES_MEMORY = "MEMORY"
--ENHANCED_COMBINATOR_TYPES_TIMER = "TIMER"

ENHANCED_COMBINATOR_TYPES = {}
ENHANCED_COMBINATOR_TYPES[1] = {
    ENHANCED_COMBINATOR_TYPES_MIN,
    ENHANCED_COMBINATOR_TYPES_MAX
}

--- Constructor
--- @param combinator this combinator (self)
--- @param entity the entity that was placed
--- @param version the version of the enhanced combinator
EnhancedCombinator = class(function(combinator, entity, version)
    combinator.entity = entity
    if entity ~= nil then
        combinator.id = create_id_from_entity(entity)
        combinator.name = entity.name
    end
    combinator.update_interval = 1
    combinator.update_counter = 0
    combinator.version = version
    combinator.type = ENHANCED_COMBINATOR_TYPES_MIN
    combinator.filter = {}
end)

function EnhancedCombinator.create_id_from_entity(entity)
    return entity.surface.name .. ":" .. entity.position.x .. ";" .. entity.position.y
end

function EnhancedCombinator.is_instance(entity)
    if entity ~= nil then
        return string.starts(entity.name, EnhancedCombinator.get_name())
    else
        return false
    end
end

function EnhancedCombinator.get_name()
    return "enhanced-combinator"
end

function EnhancedCombinator.get_id(entity)
    return create_id_from_entity(entity)
end

function EnhancedCombinator.is_gui_open(player)
    return player.gui.center[GUI_NAME]
end

function EnhancedCombinator.close_gui(player)
    if EnhancedCombinator.is_gui_open(player) then
        player.gui.center[GUI_NAME].destroy()
    end
end

function EnhancedCombinator:on_gui_opened(player)
    local window = self:gui_create_window(player)

    self:gui_create_function_frame(window)
    self:gui_create_filter_frame(window)
    self:gui_create_update_interval_frame(window)
end

--- Create the main (table) window for the combinator
function EnhancedCombinator:gui_create_window(player)
    player.opened = nil
    EnhancedCombinator.close_gui(player)

    local window = player.gui.center.add({ type = "table", name = GUI_NAME, column_count = 1, style = "enhanced-combinators-window" })

    local locale_name = { "enhanced-combinator-" .. self.version }
    local header = window.add({ type = "frame", name = "header", caption = locale_name, style = "enhanced-combinators-frame" })
    header.style.title_bottom_padding = 10
    local entity_preview = header.add { type = "entity-preview", name = "entity-preview" }
    entity_preview.entity = self.entity

    return window
end

function EnhancedCombinator1:gui_create_function_frame(window)
    local function_frame = window.add({ type = "frame", name = "function_frame", caption = { "enhanced-combinator-function" }, style = "enhanced-combinators-frame" })
    --    local choice_table = function_frame.add({ type = "table", name = "choice_table", column_count = 2 })
    --    choice_table.style.horizontal_spacing = 10
    --
    --    local min_radio_button = choice_table.add({ type = "radiobutton", name = "min_radio_button", caption = { "enhanced-combinator-min" }, state = true })
    --    local max_radio_button = choice_table.add({ type = "radiobutton", name = "max_radio_button", caption = { "enhanced-combinator-max" }, state = false })
end

--- Create filters frame
--- @param
function EnhancedCombinator1:gui_create_filter_frame(window)
    local filter_frame = window.add({ type = "frame", name = "filter_frame", caption = { "enhanced-combinator-filters" }, style = "enhanced-combinators-frame" })
    local filter_table = filter_frame.add({ type = "table", name = "filter_table", column_count = 5, style = "enhanced-combinators-filter-table" })
    local filters = {}

    for i = 1, 10 do
        local name = "filter" .. i
        local filter = filter_table.add({ type = "choose-elem-button", name = name, elem_type = "signal" })
        table.insert(filters, filter)
    end
end

function EnhancedCombinator1:gui_create_update_interval_frame(window)
    local update_interval = window.add({ type = "frame", name = "update_interval", caption = { "enhanced-combinator-update-interval" }, style = "enhanced-combinators-frame" })

    --    local update_table = update_interval.add({type = "table", name = "update_table", column_count = 3})

    local every_label = update_interval.add({ type = "label", name = "every_label", caption = "Every" })
    local interval_textfield = update_interval.add({ type = "textfield", name = "interval_textfield" })
    local tick_label = update_interval.add({ type = "label", name = "tick_label", caption = "tick(s)." })
end