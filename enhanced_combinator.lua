require "common.class"
require "common.string"
local Debug = require "common.debug"
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

--- The functionalty available for the three different combinator versions
local TYPES_AVAILABLE = {
    [1] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
        TYPES_TIMER,
    },
    [2] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
        TYPES_TIMER,
        TYPES_SORT,
        TYPES_AVERAGE,
    },
    [3] = {
        TYPES_INACTIVE,
        TYPES_MIN,
        TYPES_MAX,
        TYPES_TIMER,
        TYPES_SORT,
        TYPES_AVERAGE,
        TYPES_MEMORY,
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
local GUI_OUTPUT_SIGNAL = "output-signal"
local GUI_FRAME_ENTITY_PREVIEW = "entity-frame"
local GUI_FRAME_FUNCTION = "function-frame"


local OUTPUT_TYPE_ONE = "OUTPUT_ONE"
local OUTPUT_TYPE_INPUT_COUNT = "OUTPUT_TWO"

local SORT_ASC = "SORT_ASC"
local SORT_DESC = "SORT_DESC"

local AVERAGE_TYPE_MEAN = "mean"

local INPUT_COMBINATOR_NAME = "enhanced-combinator"
local OUTPUT_COMBINATOR_NAME = "enhanced-output-combinator"

local FILTERS_PER_VERSION = 6


-- Need to create a local function of it so we can access it in the constructor
local function create_any_id_from_entity(entity)
    return entity.surface.name .. ":" .. entity.position.x .. ";" .. entity.position.y
end

-- Need to create a local function of it so we can access it in the constructor
local function create_id_from_entity(entity)
    if string.starts(entity.name, INPUT_COMBINATOR_NAME) then
        return create_any_id_from_entity(entity)
    elseif string.starts(entity.name, OUTPUT_COMBINATOR_NAME) then
        -- Get the enhanced combinator rather than the enhanced-output-combinator
        local output_id = create_any_id_from_entity(entity)
        return global.enhanced_output_combinator_to_enhanced_combinator[output_id]
    end
end

--- Create an output combinator that is linked to an enhanced combinator.
--- @note This needs to be a local function that isn't part of EnhancedCombinator so we can access it in the
--- constructor.
--- @param enhanced_combinator the enhanced combinator to use
local function create_output_combinator(enhanced_combinator)
    local entity = enhanced_combinator.entity
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
    enhanced_combinator.output_entity = entity.surface.create_entity {
        name = OUTPUT_COMBINATOR_NAME .. "-" .. enhanced_combinator.version,
        position = output_position,
        direction = direction,
        force = entity.force,
    }

    -- Link output combinator to enhanced combinator
    if enhanced_combinator.output_entity then
        local output_entity_id = create_any_id_from_entity(enhanced_combinator.output_entity)
        global.enhanced_output_combinator_to_enhanced_combinator[output_entity_id] = enhanced_combinator.id
    else
        Debug.loge("Couldn't create Enhanced output combinator")
    end
end

--- Constructor
--- @param combinator this combinator (self)
--- @param entity the entity that was placed
local EnhancedCombinator = class(function(combinator, entity)
    combinator.entity = entity
    if entity ~= nil then
        combinator.id = create_id_from_entity(entity)
        combinator.name = entity.name
        combinator.version = tonumber(string.sub(entity.name, -1))
        Debug.logd(combinator.name .. ", version: " .. combinator.version)
    end
    combinator.update_interval = 1
    combinator.update_counter = 0
    combinator.type = TYPES_INACTIVE
    combinator.output_type = OUTPUT_TYPE_ONE
    combinator.filters = {}
    combinator.filters_lookup = {}
    combinator.average_type = AVERAGE_TYPE_MEAN

    -- Create output combinator
    if entity ~= nil then
        create_output_combinator(combinator)
    end
end)

function EnhancedCombinator.create_any_id_from_entity(entity)
    return create_any_id_from_entity(entity)
end

function EnhancedCombinator.create_id_from_entity(entity)
    return create_id_from_entity(entity)
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
    return INPUT_COMBINATOR_NAME
end

function EnhancedCombinator.get_output_name()
    return OUTPUT_COMBINATOR_NAME
end

function EnhancedCombinator:on_entity_settings_pasted(source_entity, destination_entity)
    -- Copied to the output constant combinator. Then reset it. The player should never be able to change it manually
    if destination_entity == self.output_entity then
        CircuitNetwork.clear_output_signals(destination_entity)
        self.update_counter = self.update_interval

        -- If we copied from an enhanced combinator (either input or output), copy it's values
        if self.is_instance(source_entity) then
            local other_id = self.create_id_from_entity(source_entity)
            local other_combinator = global.enhanced_combinators[other_id]
            self:copy_settings_from(other_combinator)
        else -- Just reset constant combinator
            self:on_tick()
        end

    else -- We copied to the enhanced (input) combinator
        -- Copy settings from the other enhanced (input) combinator
        if self.is_instance(source_entity) then
            local other_id = self.create_id_from_entity(source_entity)
            local other_combinator = global.enhanced_combinators[other_id]
            self:copy_settings_from(other_combinator)
        else -- Copied from an arithmetic combinator
            -- Switch back the functionality sprite as that has probably been changed
            local control = self.entity.get_control_behavior()
            CircuitNetwork.set_operation(control, TYPE_SPRITES[self.type])
        end
    end
end

--- Copy another enhanced combinator settings to this. If self.version is lower than from_combinator.version not
--- all values are copied.
--- @param from_combinator the enhanced combinator to copy values from.
function EnhancedCombinator:copy_settings_from(from_combinator)
    self.update_interval = from_combinator.update_interval
    self.output_type = from_combinator.output_type
    self.average_type = from_combinator.average_type
    self.sort_order = from_combinator.sort_order

    -- Copy filters
    for i = 1, (self.version * FILTERS_PER_VERSION) do
        local signal = from_combinator.filters[i]
        if signal then
            self.filters[i] = signal
            self.filters_lookup[signal.name] = true
        else
            local old_signal = self.filters[i]
            if old_signal then
                self.filters[i] = nil
                self.filters_lookup[old_signal.name] = nil
            end
        end
    end

    -- Change type/functionality.
    if self.version >= from_combinator.version then
        self.type = from_combinator.type
    else -- Check if it's available, if not, set to inactive
        local available = false
        for k, type in pairs(TYPES_AVAILABLE[self.version]) do
            if type == from_combinator.type then
                available = true
                break
            end
        end

        if available then
            self.type = from_combinator.type
        else
            self.type = TYPES_INACTIVE
        end
    end

    -- Update type sprite
    local control = self.entity.get_control_behavior()
    CircuitNetwork.set_operation(control, TYPE_SPRITES[self.type])
end

function EnhancedCombinator:on_tick()
    if self.type ~= TYPES_INACTIVE then
        -- Special case for clearing timer output
        if self.type == TYPES_TIMER and self.update_interval >= 0 and self.update_counter == 0 then
            CircuitNetwork.clear_output_signals(self.output_entity, 1)
        end
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
    local input_signals = CircuitNetwork.get_input(self.entity, self.filters_lookup)

    local signal_array = {}
    for signal_name, signal_info in pairs(input_signals) do
        table.insert(signal_array, signal_info)
    end

    -- ASC
    if self.sort_order == SORT_ASC then
        table.sort(signal_array, function(a, b) return a.count < b.count end)
    else
        table.sort(signal_array, function(a, b) return a.count > b.count end)
    end

    for i, signal_info in pairs(signal_array) do
        signal_info.count = i
    end

    CircuitNetwork.set_output_signals(self.output_entity, signal_array)
end

function EnhancedCombinator:on_tick_average()
    if self.output_signal then
        local input_signals = CircuitNetwork.get_input(self.entity, self.filters_lookup)

        local sum = 0
        local item_count = 0
        for signal_name, signal_info in pairs(input_signals) do
            sum = sum + signal_info.count
            item_count = item_count + 1
        end

        local average = sum / item_count
        CircuitNetwork.set_output_signal(self.output_entity, self.output_signal, average)
    else
        CircuitNetwork.clear_output_signals(self.output_entity, 1)
    end
end

function EnhancedCombinator:on_tick_timer()
    if self.output_signal then
        local count = 0
        if self.output_type == OUTPUT_TYPE_INPUT_COUNT then
            local input_signals = CircuitNetwork.get_input(self.entity)

            local filtered_input_singnal = input_signals[self.output_signal.name]
            if filtered_input_singnal then
                count = filtered_input_singnal.count
            end
        else
            count = 1
        end
        CircuitNetwork.set_output_signal(self.output_entity, self.output_signal, count)
    else
        CircuitNetwork.clear_output_signals(self.output_entity, 1)
    end
end

function EnhancedCombinator:on_tick_memory()
    local input_signals = CircuitNetwork.get_input(self.entity, self.filters_lookup)
    CircuitNetwork.set_output_signals(self.output_entity, input_signals)
end

function EnhancedCombinator:on_player_rotated_entity(event)
    Debug.logi({ "enhanced-combinator.rotation-disabled-info" })

    -- Revert the rotation
    if self.is_input_instance(event.entity) then
        self.entity.rotate()
    else
        while self.output_entity.direction ~= self.entity.direction do
            self.output_entity.rotate()
        end
    end

    -- !!! DISABLED as we cannot connect a new wire to the output combinator
    --    -- Rotate Enhanced (input) combinator
    --    if self.is_output_instance(event.entity) then
    --        self.entity.rotate()
    --    end
    --
    --    -- Move output combinator. Can only be accomplished by removing and the recreating the entity
    --    local output_id = EnhancedCombinator.create_any_id_from_entity(self.output_entity)
    --    global.enhanced_output_combinator_to_enhanced_combinator[output_id] = nil
    --    self.output_entity.destroy()
    --    create_output_combinator(self)
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
    self:gui_create_filter_frame(window)
    self:gui_create_update_interval_frame(window)
    self:gui_create_sort_frame(window)
    self:gui_create_output_frame(window)
end

--- Switch the function of this combinator
--- @param dropdown_element the drop-down GUI element
function EnhancedCombinator:switch_function(dropdown_element)
    local selected_index = dropdown_element.selected_index
    self.type = TYPES_AVAILABLE[self.version][selected_index]

    -- Update combinator display sprite
    local control = self.entity.get_control_behavior()
    CircuitNetwork.set_operation(control, TYPE_SPRITES[self.type])

    -- Clear output signals
    CircuitNetwork.clear_output_signals(self.output_entity)

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

    -- Special case for filter functionality
    if string.starts(element_name, GUI_FILTER_ELEM_BUTTON) then
        self:set_filter(element)
    else
        -- Switch-case functionality
        local action = {
            [GUI_FUNCTION_DROPDOWN] = function(self, element) self:switch_function(element) end,
            [GUI_UPDATE_INTERVAL_TEXTFIELD] = function(self, element) self:set_update_interval(element) end,
            [OUTPUT_TYPE_ONE] = function(self, element) self:set_output_type(element, OUTPUT_TYPE_ONE) end,
            [OUTPUT_TYPE_INPUT_COUNT] = function(self, element) self:set_output_type(element, OUTPUT_TYPE_INPUT_COUNT) end,
            [GUI_OUTPUT_SIGNAL] = function(self, element) self.output_signal = element.elem_value end,
            [SORT_ASC] = function(self, element) self:set_sort_order(element, SORT_ASC) end,
            [SORT_DESC] = function(self, element) self:set_sort_order(element, SORT_DESC) end,
        }

        action[element.name](self, element)
    end

    -- Reset output counter
    self.update_counter = self.update_interval
end

function EnhancedCombinator:set_sort_order(element, sort_order)
    self.sort_order = sort_order

    -- Uncheck the other radio button
    for k, radiobutton in pairs(element.parent.children) do
        if radiobutton.name ~= sort_order then
            radiobutton.state = false
        end
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
    local filter_index = tonumber(element.name:match("%d+$"))
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
    local function_frame = window.add({ type = "frame", name = GUI_FRAME_FUNCTION, caption = { "enhanced-combinator.function" }, style = "enhanced-combinators-frame" })

    local available_functions = {}
    local selected_index = 0
    for key, type in pairs(TYPES_AVAILABLE[self.version]) do
        if type == self.type then
            selected_index = key
        end
        table.insert(available_functions, TYPE_NAMES[type])
    end

    function_frame.add({ type = "drop-down", name = GUI_FUNCTION_DROPDOWN, items = available_functions, selected_index = selected_index })
end

--- Create filters frame. One row for version 1, two for version 2, three for 3.
function EnhancedCombinator:gui_create_filter_frame(window)
    if self:is_filter_functionality() then
        local filter_frame = window.add({ type = "frame", name = "filter-frame", caption = { "gui-control-behavior-modes.set-filters" }, style = "enhanced-combinators-frame" })
        local filter_table = filter_frame.add({ type = "table", name = "filter-table", column_count = FILTERS_PER_VERSION, style = "enhanced-combinators-filter-table" })

        local rows = self.version

        for i = 1, FILTERS_PER_VERSION * rows do
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
            self.type == TYPES_TIMER or
            self.type == TYPES_SORT or
            self.type == TYPES_AVERAGE or
            self.type == TYPES_MEMORY
end

function EnhancedCombinator:gui_create_sort_frame(window)
    if self:is_sort_functionality() then
        local sort_frame = window.add({ type = "frame", name = "sort-frame", caption = { "enhanced-combinator.sort" }, style = "enhanced-combinators-frame" })

        sort_frame.add({ type = "radiobutton", name = SORT_ASC, caption = { "enhanced-combinator.sort-asc" }, tooltip = { "enhanced-combinator.sort-asc-description" }, state = self.sort_order == SORT_ASC })
        sort_frame.add({ type = "radiobutton", name = SORT_DESC, caption = { "enhanced-combinator.sort-desc" }, tooltip = { "enhanced-combinator.sort-desc-description" }, state = self.sort_order == SORT_DESC })
    end
end

function EnhancedCombinator:is_sort_functionality()
    return self.type == TYPES_SORT
end

function EnhancedCombinator:gui_create_output_frame(window)
    if self:is_output_functionality() or self:is_output_signal_functionality() then
        local output_frame = window.add({ type = "frame", name = "output-frame", caption = { "gui-decider.output-item" }, style = "enhanced-combinators-frame" })

        if self:is_output_signal_functionality() then
            output_frame.add({ type = "choose-elem-button", name = GUI_OUTPUT_SIGNAL, elem_type = "signal", signal = self.output_signal })
        end

        if self:is_output_functionality() then
            local output_table = output_frame.add({ type = "table", name = "output_table", column_count = 1, style = "enhanced-combinators-radio-table" })
            output_table.add({ type = "radiobutton", name = OUTPUT_TYPE_ONE, caption = { "gui-decider.one" }, tooltip = { "gui-decider.one-description" }, state = self.output_type == OUTPUT_TYPE_ONE })
            output_table.add({ type = "radiobutton", name = OUTPUT_TYPE_INPUT_COUNT, caption = { "gui-decider.input-count" }, tooltip = { "gui-decider.input-count-description" }, state = self.output_type == OUTPUT_TYPE_INPUT_COUNT })
        end
    end
end

function EnhancedCombinator:is_output_functionality()
    return self.type == TYPES_MIN or
            self.type == TYPES_MAX or
            self.type == TYPES_TIMER
end

function EnhancedCombinator:is_output_signal_functionality()
    return self.type == TYPES_AVERAGE or
            self.type == TYPES_TIMER
end

return EnhancedCombinator