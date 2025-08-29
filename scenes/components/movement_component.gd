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
		if root_entity.game.path_handler.pathfinder.is_point_solid(coords):
			return
		root_entity.game.path_handler.pathfinder.set_point_solid(coords, true)
		root_entity.game.path_handler.pathfinder.set_point_solid(root_entity.coords, false)
	root_entity.coords = coords
