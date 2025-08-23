extends Node

class_name Generator

static func generate_test_map(size: Vector2i) -> Map:
	var map := Map.new(size)
	
	map.make_rect(Rect2i(Vector2i.ZERO, size), Tiles.TileType.WALL)
	
	map.make_rect(Rect2i(1, 1, size.x - 2, size.y - 2), Tiles.TileType.FLOOR)
	
	map.make_rect(Rect2i(3, 3, 8, 1), Tiles.TileType.WALL)
	
	return map
