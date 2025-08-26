extends Node

class_name FovComponent

@export var view_distance: int = 20

@onready var root_entity: Entity = $".."

func setup() -> void:
	root_entity.game.fov_handler.compute_fov(root_entity.coords, view_distance)

func update_fov() -> void:
	root_entity.game.fov_handler.compute_fov(root_entity.coords, view_distance)
