extends Node

const TILE_SIZE := Vector2i(32, 32)

var game_speed: int = 1

func get_ui_scale() -> int:
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		return 2
	else:
		return 1

func pos_to_coords(pos: Vector2) -> Vector2i:
	return Vector2i(floor(pos / Vector2(TILE_SIZE)))
