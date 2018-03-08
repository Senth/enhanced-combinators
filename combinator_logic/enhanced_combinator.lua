require "common.class"

EnhancedCombinator = class(function(combinator, entity)
    combinator.entity = entity
    combinator.id = create_id_from_entity(entity)
    combinator.update_interval = 1
    combinator.update_counter = 0
end)

function create_id_from_entity(entity)
    return entity.surface.name .. ":" .. entity.position.x .. ";" .. entity.position.y
end

function EnhancedCombinator:get_id(entity)
    return create_id_from_entity(entity)
end

function EnhancedCombinator:gui_create_frame(player)
    return player.gui.center.add({type = "frame", name = self.get_name(), direction = "vertical"})
end