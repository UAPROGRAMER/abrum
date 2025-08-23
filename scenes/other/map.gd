extends Resource

class_name Map

var size: Vector2i
var data: Array[Tiles.TileType]

func _init(size: Vector2i) -> void:
	self.size = size
	for y in range(size.y):
		for x in range(size.x):
			data.append(Tiles.TileType.VOID)

func is_in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < size.x and pos.y < size.y

func get_data_index(pos: Vector2i) -> int:
	return pos.x + pos.y * size.x

func set_tile(pos: Vector2i, type: Tiles.TileType) -> void:
	if not is_in_bounds(pos):
		return
	
	data[get_data_index(pos)] = type

func get_tile(pos: Vector2i) -> Tiles.TileType:
	if not is_in_bounds(pos):
		return Tiles.TileType.VOID
	
	return data[get_data_index(pos)]

func make_rect(rect: Rect2i, type: Tiles.TileType) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			set_tile(Vector2i(x, y), type)

func draw(tilemap: TileMapLayer) -> void:
	for y in range(size.y):
		for x in range(size.x):
			tilemap.set_cell(Vector2i(x, y), 0, Tiles.get_tile_data(get_tile(Vector2i(x, y))).atlas_coords)
