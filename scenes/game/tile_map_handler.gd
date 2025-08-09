extends Node

class_name TilemapHandler

var pathfinder: AStarGrid2D

func _ready() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.cell_size = Vector2i(16, 16)
	pathfinder.region = Rect2i(0, 0, 80, 45)
	pathfinder.update()

func get_id_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	return pathfinder.get_id_path(from, to)

func is_passible(coords: Vector2i) -> bool:
	return true
