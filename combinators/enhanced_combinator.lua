require "common.class"
require "common.debug"

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

--- Create the main (table) window for the combinator
--- @param locale_name header caption, which should show the localized name of the combinator
function EnhancedCombinator:create_gui_window(player, locale_name)
    player.opened = nil
    EnhancedCombinator.close_gui(player)

    local window = player.gui.center.add({ type = "table", name = GUI_NAME, column_count = 1, style = "enhanced-combinators-window"})

    local header = window.add({type = "frame", name = "header", caption = locale_name, style = "enhanced-combinators-frame"})
    header.style.title_bottom_padding = 10
    local entity_preview = header.add{type = "entity-preview", name = "entity-preview" }
    entity_preview.entity = self.entity

    return window
end