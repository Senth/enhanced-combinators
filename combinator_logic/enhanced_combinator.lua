require "common.class"

local GUI_NAME = "enhanced-combinator-gui"

EnhancedCombinator = class(function(combinator, entity)
    combinator.entity = entity
    if entity ~= nil then
        combinator.id = create_id_from_entity(entity)
        combinator.name = entity.name
    end
    combinator.update_interval = 1
    combinator.update_counter = 0
end)

function create_id_from_entity(entity)
    return entity.surface.name .. ":" .. entity.position.x .. ";" .. entity.position.y
end

function EnhancedCombinator:get_id(entity)
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

function EnhancedCombinator.gui_create_frame(player, caption)
    EnhancedCombinator.close_gui(player)
    return player.gui.center.add({ type = "frame", name = GUI_NAME, direction = "vertical", caption = caption})
end