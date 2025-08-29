extends Node

class_name PathHandler

const INT32_MAX: int = 2_147_483_647
const INT32_MIN: int = -INT32_MAX - 1

@onready var game: Game = $".."

@onready var map_handler: MapHandler = $"../map_handler"

@onready var floor_layer: TileMapLayer = $"../world/map/floor_layer"
@onready var object_layer: TileMapLayer = $"../world/map/object_layer"

var pathfinder: AStarGrid2D

func _ready() -> void:
	pathfinder = AStarGrid2D.new()
	
	pathfinder.default_compute_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	pathfinder.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	
	pathfinder.cell_size = Global.TILE_SIZE

func setup() -> void:
	update()

func update() -> void:
	var min_x: int = INT32_MAX
	var max_x: int = INT32_MIN
	var min_y: int = INT32_MAX
	var max_y: int = INT32_MIN
	
	for tile: Vector2i in floor_layer.get_used_cells():
		min_x = mini(min_x, tile.x)
		max_x = maxi(max_x, tile.x)
		min_y = mini(min_y, tile.y)
		max_y = maxi(max_y, tile.y)
	
	for tile: Vector2i in object_layer.get_used_cells():
		min_x = mini(min_x, tile.x)
		max_x = maxi(max_x, tile.x)
		min_y = mini(min_y, tile.y)
		max_y = maxi(max_y, tile.y)
	
	if min_x > max_x or min_y > max_y:
		push_error("Cant build pathfinder.")
		return
	
	pathfinder.region = Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
	
	pathfinder.update()
	
	for tile: Vector2i in floor_layer.get_used_cells():
		update_tile(tile)
	
	for tile: Vector2i in object_layer.get_used_cells():
		update_tile(tile)

func update_tile(coords: Vector2i) -> void:
	pathfinder.set_point_solid(coords, not map_handler.is_passible(coords))
