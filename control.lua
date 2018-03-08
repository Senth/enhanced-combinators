require "combinators.min_max_combinator"
require "combinators.enhanced_combinator"
require "common.debug"

local inspect = require('inspect')

local enhanced_combinators = {}


-- INIT
local function on_init()
    global.enhanced_combinators = {}
end

local function on_load()
    enhanced_combinators = global.enhanced_combinators

    -- Recreate metatables
    local min_max_metatable = getmetatable(MinMaxCombinator(nil))
    for key, value in pairs(enhanced_combinators) do
        -- Min Max
        if value.name == MinMaxCombinator:get_name() then
            setmetatable(value, min_max_metatable)
        end
    end
end


-- ENTITY
local function on_built_entity(event)
    local entity = event.created_entity
    if MinMaxCombinator.is_instance(entity) then
        local min_max_combinator = MinMaxCombinator(entity)
        enhanced_combinators[min_max_combinator.id] = min_max_combinator
        logd("Placed Min Max Combinator, id: " .. min_max_combinator.id)
    end
end

local function on_remove_entity(event)
    local entity = event.entity
    if MinMaxCombinator.is_instance(entity) then
        local entity_id = EnhancedCombinator.get_id(entity)
        enhanced_combinators[entity_id] = nil
        logd("Removed Min Max Combinator, id: " .. entity_id)
    end
end

local function on_entity_settings_pasted(event)
    local entity = event.entity
    if MinMaxCombinator.is_instance(entity) then
        logd("on_entity_settings_pasted for Min Max Combinator")
        -- TODO
    end
    logd("on_entity_settings_pasted")
end

local function on_tick()
    -- TODO
end


-- GUI
local function on_gui_opened(event)
    local opened_custom_gui = false
    local player = game.players[event.player_index]

    if event.gui_type == defines.gui_type.entity then
        local entity = event.entity
        if MinMaxCombinator.is_instance(entity) then
            local id = EnhancedCombinator.get_id(entity)
            local combinator = enhanced_combinators[id]

            if combinator and entity.valid and combinator.entity == entity then
                combinator.entity = entity
                combinator:on_gui_opened(player)
                opened_custom_gui = true
            end
        end
    end

    -- Close custom GUI if we open another (vanilla) GUI
    if not opened_custom_gui then
        -- If a custom GUI was already open, close it and don't open the vanilla GUI
        if (EnhancedCombinator.is_gui_open(player)) then
            EnhancedCombinator.close_gui(player)
            player.opened = nil
        end
    end
end

local function on_gui_click(event)
    logd("on_gui_click")
    --    local entity = event.entity
    --    if MinMaxCombinator:is_instance(entity) then
    --        logd("on_gui_click for Min Max Combinator")
    --        -- TODO
    --    end
end

local function print_combinators()
    for key, value in pairs(enhanced_combinators) do
        logd("[" .. key .. "]:" .. value.name)
    end
end

local function on_gui_changed(event)
    logd("on_gui_changed")
    --    local entity = event.entity
    --    if MinMaxCombinator:is_instance(entity) then
    --        logd("on_gui_changed for Min Max Combinator")
    --        -- TODO
    --    end
end

-- EVENTS
-- INIT
script.on_init(on_init)
script.on_load(on_load)

-- ENTITY
script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_robot_built_entity, on_built_entity)
script.on_event(defines.events.on_pre_player_mined_item, on_remove_entity)
script.on_event(defines.events.on_robot_pre_mined, on_remove_entity)
script.on_event(defines.events.on_entity_died, on_remove_entity)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_entity_settings_pasted, on_entity_settings_pasted)

-- GUI
script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_gui_click, on_gui_click)
script.on_event(defines.events.on_gui_elem_changed, on_gui_changed)
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_changed)
script.on_event(defines.events.on_gui_text_changed, on_gui_changed)