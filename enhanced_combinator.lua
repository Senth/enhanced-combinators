require "common.class"
require "common.debug"
require "common.string"
local CircuitNetwork = require "circuit_network"

local GUI_NAME_PREFIX = "enhanced-combinator-gui_"

local TYPES_INACTIVE = 0
local TYPES_MIN = 1
local TYPES_MAX = 2
local TYPES_SORT = 3
local TYPES_AVERAGE = 4
local TYPES_MEMORY = 5
local TYPES_TIMER = 6

local TYPE_SPRITES = {
    [TYPES_INACTIVE] = "*",
    [TYPES_MIN] = "-",
    [TYPES_MAX] = "+",
    [TYPES_SORT] = "/",
    [TYPES_AVERAGE] = "%",
    [TYPES_MEMORY] = "^",
    [TYPES_TIMER] = "<<",
}

--- The different types available for the three different combinator versions
local TYPES_AVAILABLE = {
    [1] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
    },
    [2] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
    },
    [3] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
    }
}

local TYPE_NAMES = {}
TYPE_NAMES[TYPES_INACTIVE] = { "enhanced-combinator.inactive" }
TYPE_NAMES[TYPES_MIN] = { "enhanced-combinator.min" }
TYPE_NAMES[TYPES_MAX] = { "enhanced-combinator.max" }
TYPE_NAMES[TYPES_SORT] = { "enhanced-combinator.sort" }
TYPE_NAMES[TYPES_AVERAGE] = { "enhanced-combinator.average" }
TYPE_NAMES[TYPES_MEMORY] = { "enhanced-combinator.memory" }
TYPE_NAMES[TYPES_TIMER] = { "enhanced-combinator.timer" }

local GUI_FUNCTION_DROPDOWN = "function-drop-down"
local GUI_UPDATE_INTERVAL_TEXTFIELD = "update_interval-textfield"
local GUI_FILTER_ELEM_BUTTON = "filter-"
local GUI_FRAME_ENTITY_PREVIEW = "entity-frame"
local GUI_FRAME_FUNCTION = "function-frame"

local OUTPUT_TYPE_ONE = "1"
local OUTPUT_TYPE_INPUT_COUNT = "2"

--- Constructor
--- @param combinator this combinator (self)
--- @param entity the entity that was placed
EnhancedCombinator = class(function(combinator, entity)
    combinator.entity = entity
    if entity ~= nil then
        combinator.id = EnhancedCombinator.create_id_from_entity(entity)
        combinator.name = entity.name
        combinator.version = tonumber(string.sub(entity.name, -1))
        logd(combinator.name .. ", version: " .. combinator.version)
    end
    combinator.update_interval = 1
    combinator.update_counter = 0
    combinator.type = TYPES_INACTIVE
    combinator.output_state = OUTPUT_TYPE_ONE
    combinator.filters = {}
    combinator.filters_lookup = {}

    -- Create output combinator
    if entity ~= nil then
        EnhancedCombinator.create_output_combinator(combinator, entity)
        -- Link output combinator to enhanced combinator
        --        if combinator.output_entity then
        --            local output_entity_id = EnhancedCombinator.create_any_id_from_entity(combinator.output_entity)
        --            global.enhanced_output_combinator_to_enhanced_combinator[output_entity_id] = combinator.id
        --        else
        --            loge("Couldn't create Enhanced output combinator")
        --        end
    end
end)

--- Create an output combinator that is linked to an enhanced combinator
--- @param entity Enhanced Combinator entity
function EnhancedCombinator:create_output_combinator(entity)
    local direction = entity.direction
    local output_position
    if direction == defines.direction.north then
        output_position = {
            x = entity.position.x,
            y = entity.position.y - 0.5,
        }
    elseif direction == defines.direction.south then
        output_position = {
            x = entity.position.x,
            y = entity.position.y + 0.5,
        }
    elseif direction == defines.direction.west then
        output_position = {
            x = entity.position.x - 0.5,
            y = entity.position.y,
        }
    elseif direction == defines.direction.east then
        output_position = {
            x = entity.position.x + 0.5,
            y = entity.position.y,
        }
    end
    self.output_entity = entity.surface.create_entity {
        name = "enhanced-output-combinator-" .. self.version,
        position = output_position,
        direction = direction,
        force = entity.force,
    }

    -- Link output combinator to enhanced combinator
    if self.output_entity then
        local output_entity_id = EnhancedCombinator.create_any_id_from_entity(self.output_entity)
        global.enhanced_output_combinator_to_enhanced_combinator[output_entity_id] = self.id
    else
        loge("Couldn't create Enhanced output combinator")
    end
end

function EnhancedCombinator.create_id_from_entity(entity)
    if string.starts(entity.name, EnhancedCombinator.get_name()) then
        return EnhancedCombinator.create_any_id_from_entity(entity)
    elseif string.starts(entity.name, EnhancedCombinator.get_output_name()) then
        -- Get the enhanced combinator rather than the enhanced-output-combinator
        local output_id = EnhancedCombinator.create_any_id_from_entity(entity)
        return global.enhanced_output_combinator_to_enhanced_combinator[output_id]
    end
end

function EnhancedCombinator.create_any_id_from_entity(entity)
    return entity.surface.name .. ":" .. entity.position.x .. ";" .. entity.position.y
end

function EnhancedCombinator.is_instance(entity)
    if entity ~= nil then
        return EnhancedCombinator.is_input_instance(entity) or EnhancedCombinator.is_output_instance(entity)
    else
        return false
    end
end

function EnhancedCombinator.is_input_instance(entity)
    return string.starts(entity.name, EnhancedCombinator.get_name())
end

function EnhancedCombinator.is_output_instance(entity)
    return string.starts(entity.name, EnhancedCombinator.get_output_name())
end

function EnhancedCombinator.get_name()
    return "enhanced-combinator"
end

function EnhancedCombinator.get_output_name()
    return "enhanced-output-combinator"
end

function EnhancedCombinator:on_tick()
    if self.type ~= TYPES_INACTIVE then
        self.update_counter = self.update_counter + 1

        if self.update_counter >= self.update_interval then
            self.update_counter = 0

            if self.type == TYPES_MIN then
                self:on_tick_min()
            elseif self.type == TYPES_MAX then
                self:on_tick_max()
            elseif self.type == TYPES_SORT then
                self:on_tick_sort()
            elseif self.type == TYPES_AVERAGE then
                self:on_tick_average()
            elseif self.type == TYPES_TIMER then
                self:on_tick_timer()
            elseif self.type == TYPES_MEMORY then
                self:on_tick_memory()
            end
        end
    end
end

function EnhancedCombinator:on_tick_min()
    local input_signals = CircuitNetwork.get_input(self.entity, self.filters_lookup)

    local min_signal
    local min_count = math.huge
    for signal_name, signal_info in pairs(input_signals) do
        if signal_info.count < min_count then
            min_signal = signal_info.signal
            min_count = signal_info.count
        end
    end

    if min_signal then
        logd("Min signal: " .. min_signal.name .. ", with count: " .. min_count)
        local count = min_count
        if self.output_type == OUTPUT_TYPE_ONE then
            count = 1
        end
        CircuitNetwork.set_output_signal(self.output_entity, min_signal, count)
    else
        CircuitNetwork.clear_output_signals(self.output_entity, 1)
    end
end

function EnhancedCombinator:on_tick_max()
    local input_signals = CircuitNetwork.get_input(self.entity, self.filters_lookup)

    local max_signal
    local max_count = -math.huge
    for signal_name, signal_info in pairs(input_signals) do
        if signal_info.count > max_count then
            max_signal = signal_info.signal
            max_count = signal_info.count
        end
    end

    if max_signal then
        logd("Max signal: " .. max_signal.name .. ", with count: " .. max_count)
        local count = max_count
        if self.output_type == OUTPUT_TYPE_ONE then
            count = 1
        end
        CircuitNetwork.set_output_signal(self.output_entity, max_signal, count)
    else
        CircuitNetwork.clear_output_signals(self.output_entity, 1)
    end
end

function EnhancedCombinator:on_tick_sort()
end

function EnhancedCombinator:on_tick_average()
end

function EnhancedCombinator:on_tick_timer()
end

function EnhancedCombinator:on_tick_memory()
end

function EnhancedCombinator:on_player_rotated_entity(event)
    -- Rotate Enhanced (input) combinator
    if self.is_output_instance(event.entity) then
        self.entity.rotate()
    end

    -- Move output combinator. Can only be accomplished by removing and the recreating the entity
    local output_id = EnhancedCombinator.create_any_id_from_entity(self.output_entity)
    global.enhanced_output_combinator_to_enhanced_combinator[output_id] = nil
    self.output_entity.destroy()
    self:create_output_combinator(self.entity)
end

function EnhancedCombinator.get_event_combinator(event)
    local element = event.element
    while element ~= nil do
        if string.starts(element.name, GUI_NAME_PREFIX) then
            local combinator_id_start = string.find(element.name, "_")
            local combinator_id = string.sub(element.name, combinator_id_start + 1)
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
    self:create_optional_frames(window)
end

function EnhancedCombinator:create_optional_frames(window)
    logd("Create optional frames")
    self:gui_create_filter_frame(window)
    self:gui_create_update_interval_frame(window)
    self:gui_create_output_frame(window)
end

function EnhancedCombinator:on_gui_click(event)
    -- TODO
end

--- Switch the function of this combinator
--- @param dropdown_element the drop-down GUI element
function EnhancedCombinator:switch_function(dropdown_element)
    local selected_index = dropdown_element.selected_index
    self.type = TYPES_AVAILABLE[self.version][selected_index]

    -- Update combinator display sprite
    logd("Changing to sprite: " .. TYPE_SPRITES[self.type])
    local control = self.entity.get_or_create_control_behavior()
    CircuitNetwork.set_operation(control, TYPE_SPRITES[self.type])

    -- Update GUI frames
    local root_window = self:get_root_window(dropdown_element)
    if root_window then
        self:clear_optional_frames(root_window)
        self:create_optional_frames(root_window)
    end
end

--- Get the root window frame from an element
--- @param element the element to get the root window from
--- @return root window of the element
function EnhancedCombinator:get_root_window(element)
    local root_window_name = GUI_NAME_PREFIX .. self.id
    while element ~= nil do
        if element.name == root_window_name then
            return element
        end
        element = element.parent
    end
end

--- Clear all the optional frames. I.e., all children frames expect the entity-preview frame
--- and the functioanlity frame.
--- @param window the parent window of all frames
function EnhancedCombinator:clear_optional_frames(window)
    for k, frame in pairs(window.children) do
        if frame.name ~= GUI_FRAME_FUNCTION and frame.name ~= GUI_FRAME_ENTITY_PREVIEW then
            frame.destroy()
        end
    end
end

function EnhancedCombinator:on_gui_changed(event)
    local element = event.element
    local element_name = element.name
    logd(element_name .. " - " .. self.id)

    -- Special case for filter functionality
    if string.starts(element_name, GUI_FILTER_ELEM_BUTTON) then
        self:set_filter(element)
    else
        -- Switch-case functionality
        local action = {
            [GUI_FUNCTION_DROPDOWN] = function(self, element) self:switch_function(element) end,
            [GUI_UPDATE_INTERVAL_TEXTFIELD] = function(self, element) self:set_update_interval(element) end,
            [OUTPUT_TYPE_ONE] = function(self, element) self:set_output_type(element, OUTPUT_TYPE_ONE) end,
            [OUTPUT_TYPE_INPUT_COUNT] = function(self, element) self:set_output_type(element, OUTPUT_TYPE_INPUT_COUNT) end
        }

        action[element.name](self, element)
    end
end

function EnhancedCombinator:set_output_type(element, output_type)
    self.output_type = output_type

    -- Uncheck the other radio button
    for k, radiobutton in pairs(element.parent.children) do
        if radiobutton.name ~= output_type then
            radiobutton.state = false
        end
    end
end

function EnhancedCombinator:set_filter(element)
    local filter_index = tonumber(element.name:match("%d$"))
    local old_signal = self.filters[filter_index]
    if element.elem_value then
        self.filters_lookup[element.elem_value.name] = true
    elseif old_signal then
        self.filters_lookup[old_signal.name] = nil
    end
    self.filters[filter_index] = element.elem_value
end

function EnhancedCombinator:set_update_interval(element)
    -- Validate textfield
    local text = element.text

    -- Skip validation if empty (we want to allow users to erase the field)
    if text:len() > 0 then
        local non_digit = text:match("%D")
        local begins_with_zero = text:match("^0")
        local too_long = text:len() > 6
        -- Reset GUI update interval, to fix invalid attempts
        if non_digit or begins_with_zero or too_long then
            element.text = self.update_interval
        else
            -- Okay update interval value, set it
            self.update_interval = tonumber(text)
        end
    else
        self.update_interval = 1
    end
end

--- Create the main (table) window for the combinator
function EnhancedCombinator:gui_create_window(player)
    EnhancedCombinator.close_gui(player)

    local gui_name = GUI_NAME_PREFIX .. self.id
    global.enhanced_combinators_open_guis[player.index] = gui_name

    local window = player.gui.center.add({ type = "table", name = gui_name, column_count = 1, style = "enhanced-combinators-window" })

    local locale_name = { "entity-name.enhanced-combinator-" .. self.version }
    local header = window.add({ type = "frame", name = GUI_FRAME_ENTITY_PREVIEW, caption = locale_name, style = "enhanced-combinators-frame" })
    local entity_preview = header.add { type = "entity-preview", name = "entity-preview" }
    entity_preview.entity = self.entity

    return window
end

function EnhancedCombinator:gui_create_function_frame(window)
    self.function_frame = window.add({ type = "frame", name = GUI_FRAME_FUNCTION, caption = { "enhanced-combinator.function" }, style = "enhanced-combinators-frame" })

    local available_functions = {}
    local selected_index = 0
    for key, type in pairs(TYPES_AVAILABLE[self.version]) do
        if type == self.type then
            selected_index = key
        end
        table.insert(available_functions, TYPE_NAMES[type])
    end

    self.function_frame.add({ type = "drop-down", name = GUI_FUNCTION_DROPDOWN, items = available_functions, selected_index = selected_index })
end

--- Create filters frame. One row for version 1, two for version 2, three for 3.
function EnhancedCombinator:gui_create_filter_frame(window)
    if self:is_filter_functionality() then
        local filter_frame = window.add({ type = "frame", name = "filter-frame", caption = { "gui-control-behavior-modes.set-filters" }, style = "enhanced-combinators-frame" })
        local filter_table = filter_frame.add({ type = "table", name = "filter-table", column_count = 6, style = "enhanced-combinators-filter-table" })

        local rows = self.version

        for i = 1, 6 * rows do
            local name = GUI_FILTER_ELEM_BUTTON .. i
            local filter = filter_table.add({ type = "choose-elem-button", name = name, elem_type = "signal" })
            filter.elem_value = self.filters[i]
        end
    end
end

function EnhancedCombinator:is_filter_functionality()
    return self.type == TYPES_MIN or
            self.type == TYPES_MAX or
            self.type == TYPES_SORT or
            self.type == TYPES_AVERAGE or
            self.type == TYPES_MEMORY
end

function EnhancedCombinator:gui_create_update_interval_frame(window)
    if self:is_update_interval_functionality() then
        local update_interval_frame = window.add({ type = "frame", name = "update-interval-frame", caption = { "enhanced-combinator.update-interval" }, style = "enhanced-combinators-frame" })

        update_interval_frame.add({ type = "label", name = "every_label", caption = "Every" })
        local textfield = update_interval_frame.add({ type = "textfield", name = GUI_UPDATE_INTERVAL_TEXTFIELD, style = "enhanced-combinators-update-interval-textfield" })
        textfield.text = self.update_interval
        update_interval_frame.add({ type = "label", name = "tick_label", caption = "tick(s)." })
    end
end

function EnhancedCombinator:is_update_interval_functionality()
    return self.type == TYPES_MIN or
            self.type == TYPES_MAX or
            self.type == TYPES_SORT or
            self.type == TYPES_AVERAGE or
            self.type == TYPES_MEMORY
end

function EnhancedCombinator:gui_create_output_frame(window)
    if self:is_output_functionality() then
        local output_frame = window.add({ type = "frame", name = "output-frame", caption = { "gui-decider.output-item" }, style = "enhanced-combinators-frame" })

        -- TODO radio buttons
        --    logd("output state: " .. self.output_type)
        local radio_1 = output_frame.add({ type = "radiobutton", name = OUTPUT_TYPE_ONE, caption = { "gui-decider.one" }, tooltip = { "gui-decider.one-description" }, state = self.output_type == OUTPUT_TYPE_ONE })
        output_frame.add({ type = "radiobutton", name = OUTPUT_TYPE_INPUT_COUNT, caption = { "gui-decider.input-count" }, tooltip = { "gui-decider.input-count-description" }, state = self.output_type == OUTPUT_TYPE_INPUT_COUNT })
    end
end

function EnhancedCombinator:is_output_functionality()
    return self.type == TYPES_MIN or
            self.type == TYPES_MAX
end