local EnhancedCombinator = require "enhanced_combinator"
local Debug = require "common.debug"

local enhanced_combinators = {}
local enhanced_output_combinator_to_enhanced_combinator = {}

-- INIT
local function on_init()
    global.enhanced_combinators = {}
    global.enhanced_combinators_opened_guis = {}
    global.enhanced_output_combinator_to_enhanced_combinators = {}
end

local function on_load()
    enhanced_combinators = global.enhanced_combinators
    enhanced_output_combinator_to_enhanced_combinator = global.enhanced_output_combinator_to_enhanced_combinator

    -- Recreate metatables
    local enhanced_combinator_metatable = getmetatable(EnhancedCombinator(nil))
    for key, value in pairs(enhanced_combinators) do
        setmetatable(value, enhanced_combinator_metatable)
    end
end


-- ENTITY
local function on_built_entity(event)
    local entity = event.created_entity
    if EnhancedCombinator.is_instance(entity) then
        local enhanced_combinator = EnhancedCombinator(entity)
        enhanced_combinators[enhanced_combinator.id] = enhanced_combinator
        Debug.logd("Placed Enhanced Combinator, name: " .. entity.name .. ", id: " .. enhanced_combinator.id)
    end
end

local function on_remove_entity(event)
    local entity = event.entity
    if EnhancedCombinator.is_input_instance(entity) then
        local input_entity_id = EnhancedCombinator.create_any_id_from_entity(entity)
        local enhanced_combinator = enhanced_combinators[input_entity_id]
        local output_entity_id = EnhancedCombinator.create_any_id_from_entity(enhanced_combinator.output_entity)
        enhanced_combinator.output_entity.destroy()
        enhanced_combinators[input_entity_id] = nil
        enhanced_output_combinator_to_enhanced_combinator[output_entity_id] = nil
        Debug.logd("Removed Enhanced Combinator, id: " .. input_entity_id)
    elseif EnhancedCombinator.is_output_instance(entity) then
        local output_entity_id = EnhancedCombinator.create_any_id_from_entity(entity)
        local input_entity_id = EnhancedCombinator.create_id_from_entity(entity)
        local enhanced_combinator = enhanced_combinators[input_entity_id]
        enhanced_combinator.entity.destroy()
        enhanced_combinators[input_entity_id] = nil
        enhanced_output_combinator_to_enhanced_combinator[output_entity_id] = nil
        Debug.logd("Removed Enhanced Output Combinator, id: " .. output_entity_id)
    end
end

local function on_entity_settings_pasted(event)
    local entity = event.entity
    if EnhancedCombinator.is_instance(entity) then
        Debug.logd("on_entity_settings_pasted for Enhanced Combinator")
        -- TODO
    end
    Debug.logd("on_entity_settings_pasted")
end

local function on_tick()
    for k, enhanced_combinator in pairs(enhanced_combinators) do
        enhanced_combinator:on_tick()
    end
end

local function on_entity_damaged(event)
    local entity = event.entity
    if EnhancedCombinator.is_instance(entity) then
        Debug.logd("on_entity_settings_pasted for Enhanced Combinator")
        -- TODO
    end
    Debug.logd("on_entity_settings_pasted")
end

local function on_entity_died(event)
    local entity = event.entity
    if EnhancedCombinator.is_instance(entity) then
        Debug.logd("on_entity_settings_pasted for Enhanced Combinator")
        -- TODO
    end
    Debug.logd("on_entity_settings_pasted")
end


-- GUI
local function on_gui_opened(event)
    local opened_custom_gui = false
    local player = game.players[event.player_index]

    if event.gui_type == defines.gui_type.entity then
        local entity = event.entity
        Debug.logd("opened name: " .. entity.name)
        if EnhancedCombinator.is_instance(entity) then
            local id = EnhancedCombinator.create_id_from_entity(entity)
            local combinator = enhanced_combinators[id]

            if combinator and entity.valid and (combinator.entity == entity or combinator.output_entity == entity) then
                combinator:on_gui_opened(player)
                opened_custom_gui = true

                -- Close vanilla GUI
                player.opened = nil
            end
        end
    end

    -- Close custom GUI if we opened another (vanilla) GUI
    if not opened_custom_gui then
        -- If a custom GUI was already open, close it and don't open the vanilla GUI
        if (EnhancedCombinator.is_gui_open(player)) then
            EnhancedCombinator.close_gui(player)
            player.opened = nil
        end
    end
end

local function on_gui_changed(event)
    Debug.logd("on_gui_changed")
    local combinator = EnhancedCombinator.get_event_combinator(event)
    if combinator then
        combinator:on_gui_changed(event)
    end
end

local function on_player_rotated_entity(event)
    Debug.logd("on_player_rotated_entity")
    local entity = event.entity
    if EnhancedCombinator.is_instance(entity) then
        local combinator_id = EnhancedCombinator.create_id_from_entity(entity)
        local combinator = enhanced_combinators[combinator_id]
        combinator:on_player_rotated_entity(event)
    end
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
script.on_event(defines.events.on_entity_damaged, on_entity_damaged)
script.on_event(defines.events.on_entity_died, on_entity_died)

-- GUI
script.on_event(defines.events.on_gui_opened, on_gui_opened)
script.on_event(defines.events.on_gui_elem_changed, on_gui_changed)
script.on_event(defines.events.on_gui_selection_state_changed, on_gui_changed)
script.on_event(defines.events.on_gui_text_changed, on_gui_changed)
script.on_event(defines.events.on_gui_checked_state_changed, on_gui_changed)
script.on_event(defines.events.on_player_rotated_entity, on_player_rotated_entity)