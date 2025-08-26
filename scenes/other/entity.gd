extends Node2D

class_name Entity

@onready var game: Game = $"../../.."

@export var coords: Vector2i:
	set(new_coords):
		coords = new_coords
		position = coords * Global.TILE_SIZE

func setup() -> void:
	pass

func take_turn(turn: int) -> void:
	pass
