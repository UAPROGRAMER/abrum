extends Node

class_name MovementComponent

@export var intangible: bool = false

@onready var root_entity: Entity = $".."

func _ready() -> void:
	if intangible:
		return
	await root_entity.entity_ready
	root_entity.game.pathfinder.set_point_solid(root_entity.coords, true)

func move_to(coords: Vector2i) -> void:
	if not intangible:
		if root_entity.game.pathfinder.is_point_solid(coords):
			return
		root_entity.game.pathfinder.set_point_solid(coords, true)
		root_entity.game.pathfinder.set_point_solid(root_entity.coords, false)
	root_entity.coords = coords
