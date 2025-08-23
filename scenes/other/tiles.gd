extends Node

class_name Tiles

enum TileType {
	VOID,
	FLOOR,
	WALL
}

static var tiles: Dictionary[TileType, TileDataResource] = {
	TileType.VOID: TileDataResource.new(Vector2i(-1, -1), false),
	TileType.FLOOR: TileDataResource.new(Vector2i(1, 0), true),
	TileType.WALL: TileDataResource.new(Vector2i(0, 0), false)
}

static func get_tile_data(type: TileType) -> TileDataResource:
	return tiles.get(type)
