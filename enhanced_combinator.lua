require "common.class"
require "common.debug"
require "common.string"

local GUI_NAME_PREFIX = "enhanced-combinator-gui_"

ENHANCED_COMBINATOR_TYPES_INACTIVE = 0
ENHANCED_COMBINATOR_TYPES_MIN = 1
ENHANCED_COMBINATOR_TYPES_MAX = 2
ENHANCED_COMBINATOR_TYPES_SORT = 3
ENHANCED_COMBINATOR_TYPES_AVERAGE = 4
ENHANCED_COMBINATOR_TYPES_MEMORY = 5
ENHANCED_COMBINATOR_TYPES_TIMER = 6

local TYPES = {}
TYPES[1] = {
    ENHANCED_COMBINATOR_TYPES_INACTIVE,
    ENHANCED_COMBINATOR_TYPES_MIN,
    ENHANCED_COMBINATOR_TYPES_MAX,
}
TYPES[2] = {
    ENHANCED_COMBINATOR_TYPES_INACTIVE,
    ENHANCED_COMBINATOR_TYPES_MIN,
    ENHANCED_COMBINATOR_TYPES_MAX,
}
TYPES[3] = {
    ENHANCED_COMBINATOR_TYPES_INACTIVE,
    ENHANCED_COMBINATOR_TYPES_MIN,
    ENHANCED_COMBINATOR_TYPES_MAX,
}

local TYPE_NAMES = {}
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_INACTIVE] = { "enhanced-combinator-inactive" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_MIN] = { "enhanced-combinator-min" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_MAX] = { "enhanced-combinator-max" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_SORT] = { "enhanced-combinator-sort" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_AVERAGE] = { "enhanced-combinator-average" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_MEMORY] = { "enhanced-combinator-memory" }
TYPE_NAMES[ENHANCED_COMBINATOR_TYPES_TIMER] = { "enhanced-combinator-timer" }

--- Constructor
--- @param combinator this combinator (self)
--- @param entity the entity that was placed
EnhancedCombinator = class(function(combinator, entity)
    combinator.entity = entity
    if entity ~= nil then
        combinator.id = EnhancedCombinator.create_id_from_entity(entity)
        combinator.name = entity.name
        combinator.version = tonumber(string.sub(entity.name, -1))
    end
    combinator.update_interval = 1
    combinator.update_counter = 0
    combinator.type = ENHANCED_COMBINATOR_TYPES_INACTIVE
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

function EnhancedCombinator:on_tick()
    -- TODO
end

function EnhancedCombinator.get_event_combinator(event)
    local element = event.element
    local combinator = nil
    while element ~= nil or combinator ~= nil do
        if string.starts(element.name, GUI_NAME_PREFIX) then
            local combinator_id_start = string.find(element.name, "_")
            local combinator_id = string.sub(element.name, combinator_id_start+1)
            logd("Found combinator id: " .. combinator_id)
            return global.enhanced_combinators[combinator_id]
        end
        element = element.parent
    end
end

function EnhancedCombinator.is_gui_open(player)
    return global.enhanced_combinators_open_guis[player.index] ~= nil
end

function EnhancedCombinator.close_gui(player)
    if EnhancedCombinator.is_gui_open(player) then
        local gui_name = global.enhanced_combinators_open_guis[player.index]
        player.gui.center[gui_name].destroy()
        global.enhanced_combinators_open_guis[player.index] = nil
    end
end

function EnhancedCombinator:on_gui_opened(player)
    local window = self:gui_create_window(player)

    self:gui_create_function_frame(window)
    self:gui_create_filter_frame(window)
    self:gui_create_update_interval_frame(window)
end

function EnhancedCombinator:on_gui_click(event)
    -- TODO
end

function EnhancedCombinator:on_gui_changed(event)
    -- TODO
end

--- Create the main (table) window for the combinator
function EnhancedCombinator:gui_create_window(player)
    EnhancedCombinator.close_gui(player)

    local gui_name = GUI_NAME_PREFIX .. self.id
    global.enhanced_combinators_open_guis[player.index] = gui_name

    local window = player.gui.center.add({ type = "table", name = gui_name, column_count = 1, style = "enhanced-combinators-window" })

    local locale_name = { "enhanced-combinator-name-" .. self.version }
    local header = window.add({ type = "frame", name = "header", caption = locale_name, style = "enhanced-combinators-frame" })
    header.style.title_bottom_padding = 10
    local entity_preview = header.add { type = "entity-preview", name = "entity-preview" }
    entity_preview.entity = self.entity

    return window
end

function EnhancedCombinator:gui_create_function_frame(window)
    self.function_frame = window.add({ type = "frame", name = "function_frame", caption = { "enhanced-combinator-function" }, style = "enhanced-combinators-frame" })

    local available_functions = {}
    local selected_index = 0
    for key, type in pairs(TYPES[self.version]) do
        if type == self.type then
            selected_index = key
        end
        table.insert(available_functions, TYPE_NAMES[type])
    end

    local dropdown = self.function_frame.add({ type = "drop-down", name = "function_drop_down", items = available_functions, selected_index = selected_index })
end

--- Create filters frame. One row for version 1, two for version 2, three for 3.
function EnhancedCombinator:gui_create_filter_frame(window)
    if self:is_filter_functionality() and self.filter_frame == nil then
        self.filter_frame = window.add({ type = "frame", name = "filter_frame", caption = { "enhanced-combinator-filters" }, style = "enhanced-combinators-frame" })
        local filter_table = self.filter_frame.add({ type = "table", name = "filter_table", column_count = 6, style = "enhanced-combinators-filter-table" })
        local filters = {}

        local rows = self.version

        for i = 1, 6 * rows do
            local name = "filter" .. i
            local filter = filter_table.add({ type = "choose-elem-button", name = name, elem_type = "signal" })
            table.insert(filters, filter)
        end
    end
end

function EnhancedCombinator:is_filter_functionality()
    return self.type == ENHANCED_COMBINATOR_TYPES_MIN or
            self.type == ENHANCED_COMBINATOR_TYPES_MAX or
            self.type == ENHANCED_COMBINATOR_TYPES_SORT or
            self.type == ENHANCED_COMBINATOR_TYPES_AVERAGE or
            self.type == ENHANCED_COMBINATOR_TYPES_MEMORY
end

function EnhancedCombinator:gui_create_update_interval_frame(window)
    if self:is_update_interval_functionality() and self.update_interval_frame == nil then
        self.update_interval_frame = window.add({ type = "frame", name = "update_interval", caption = { "enhanced-combinator-update-interval" }, style = "enhanced-combinators-frame" })

        --    local update_table = update_interval.add({type = "table", name = "update_table", column_count = 3})

        local every_label = self.update_interval_frame.add({ type = "label", name = "every_label", caption = "Every" })
        local interval_textfield = self.update_interval_frame.add({ type = "textfield", name = "interval_textfield" })
        local tick_label = self.update_interval_frame.add({ type = "label", name = "tick_label", caption = "tick(s)." })
    end
end

function EnhancedCombinator:is_update_interval_functionality()
    return self.type == ENHANCED_COMBINATOR_TYPES_MIN or
            self.type == ENHANCED_COMBINATOR_TYPES_MAX or
            self.type == ENHANCED_COMBINATOR_TYPES_SORT or
            self.type == ENHANCED_COMBINATOR_TYPES_AVERAGE or
            self.type == ENHANCED_COMBINATOR_TYPES_MEMORY
end