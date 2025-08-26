extends Node

class_name MovementComponent

@export var intangible: bool = false

@onready var root_entity: Entity = $".."

func setup() -> void:
	if intangible:
		return
	root_entity.game.path_handler.pathfinder.set_point_solid(root_entity.coords, true)

func move_to(coords: Vector2i) -> void:
	if not intangible:
		if not root_entity.game.map_handler.is_passible(coords):
			return
		root_entity.game.path_handler.pathfinder.set_point_solid(coords, true)
		root_entity.game.path_handler.pathfinder.set_point_solid(root_entity.coords, false)
	root_entity.coords = coords
