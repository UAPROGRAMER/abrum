extends Node2D

class_name Entity

signal entity_ready()

@onready var game: Game = $"../.."

var coords: Vector2i:
	set(new_coords):
		coords = new_coords
		position = coords * Global.TILE_SIZE

func _ready() -> void:
	entity_ready.emit()

func take_turn(turn: int) -> void:
	pass
