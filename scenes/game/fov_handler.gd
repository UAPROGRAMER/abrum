extends Node

class_name FovHandler

@onready var map_handler: MapHandler = $"../map_handler"

@onready var floor_layer: TileMapLayer = $"../world/map/floor_layer"
@onready var object_layer: TileMapLayer = $"../world/map/object_layer"

@onready var floor_memory_layer: TileMapLayer = $"../world/map_overlay/floor_memory_layer"
@onready var object_memory_layer: TileMapLayer = $"../world/map_overlay/object_memory_layer"
@onready var fov_layer: TileMapLayer = $"../world/map_overlay/fov_layer"

var origin: Vector2i
var max_distance: int
var max_distance_squared: int
var currentQuadrant: Quadrant

var floor_memory: Dictionary[Vector2i, Vector2i]
var object_memory: Dictionary[Vector2i, Vector2i]

func setup() -> void:
	reset()

func reset() -> void:
	floor_memory = {}
	object_memory = {}
	floor_memory_layer.clear()
	object_memory_layer.clear()
	fov_layer.clear()
	fill_fov()

func fill_fov() -> void:
	for tile: Vector2i in object_layer.get_used_cells():
		fov_layer.set_cell(tile, 0, Vector2i.ZERO)
	for tile: Vector2i in floor_layer.get_used_cells():
		fov_layer.set_cell(tile, 0, Vector2i.ZERO)

func reset_memory() -> void:
	for tile: Vector2i in floor_memory.keys():
		floor_memory_layer.set_cell(tile, 0, floor_memory[tile])
	for tile: Vector2i in object_memory.keys():
		object_memory_layer.set_cell(tile, 0, object_memory[tile])
	floor_memory = {}
	object_memory = {}

func mark_visible(coords: Vector2i) -> void:
	fov_layer.erase_cell(coords)
	floor_memory[coords] = floor_layer.get_cell_atlas_coords(coords)
	object_memory[coords] = object_layer.get_cell_atlas_coords(coords)
	floor_memory_layer.erase_cell(coords)
	object_memory_layer.erase_cell(coords)

func compute_fov(origin: Vector2i, max_distance: int):
	self.origin = origin
	self.max_distance = max_distance
	max_distance_squared = max_distance * max_distance
	
	reset_memory()
	
	mark_visible(origin)
	
	for i in range(4):
		currentQuadrant = Quadrant.new(i, origin)
		var first_row = Row.new(1, Fraction.new(-1.0, 1.0), Fraction.new(1.0, 1.0))
		scan(first_row)

func scan(row: Row):
	if row.depth > max_distance:
		return
	var prev_tile = null
	for tile in row.tiles():
		var coords: Vector2i = currentQuadrant.transform(tile)
		
		if coords.distance_squared_to(origin) > max_distance_squared:
			continue
		
		if is_wall(tile) or is_symmetric(row, tile):
			reveal(tile)
		
		if is_wall(prev_tile) and is_floor(tile):
			row.start_slope = slope(tile)
		
		if is_floor(prev_tile) and is_wall(tile):
			var next_row = row.next()
			next_row.end_slope = slope(tile)
			scan(next_row)
		
		prev_tile = tile
	
	if is_floor(prev_tile):
		scan(row.next())

func slope(tile):
	var row_depth = tile.x
	var col = tile.y
	return Fraction.new((2 * col - 1), (2 * row_depth))

func is_symmetric(row: Row, tile) -> bool:
	# this variable isn't actually used
	var _row_depth = tile.x
	var col = tile.y
	return (col >= row.depth * row.start_slope.toFloat()
			and col <= row.depth * row.end_slope.toFloat())

func reveal(tile):
	mark_visible(currentQuadrant.transform(tile))

func is_wall(tile) -> bool:
	if tile == null:
		return false
	return not map_handler.is_seethrough(currentQuadrant.transform(tile))

func is_floor(tile) -> bool:
	if tile == null:
		return false
	return map_handler.is_seethrough(currentQuadrant.transform(tile))

class Quadrant:
	var north = 0
	var east = 1
	var south = 2
	var west = 3
	
	var cardinal
	var ox
	var oy
	
	func _init(_cardinal: int, _origin: Vector2i):
		self.cardinal = _cardinal
		self.ox = _origin.x
		self.oy = _origin.y
	
	func transform(tile):
		var row = tile.x
		var col = tile.y
		if cardinal == north:
			return Vector2i(ox + col, oy - row)
		if cardinal == south:
			return Vector2i(ox + col, oy + row)
		if cardinal == east:
			return Vector2i(ox + row, oy + col)
		if cardinal == west:
			return Vector2i(ox - row, oy + col)
	
class Row:
	var depth
	var start_slope
	var end_slope
	
	func _init(_depth, _start_slope : Fraction, _end_slope : Fraction):
		self.depth = _depth
		self.start_slope = _start_slope
		self.end_slope = _end_slope
	
	func tiles():
		var tilesArr = []
		tilesArr.clear()
		var min_col = round_ties_up(depth * start_slope.toFloat())
		var max_col = round_ties_down(depth * end_slope.toFloat())
		# i have no idea why the original source has max_col+1 and works fine
		# but here in godot i need max_col+2 for it to function properly.
		for col in range(min_col, max_col+2):
			tilesArr.append(Vector2(depth, col))
		return tilesArr
	
	func next() -> Row:
		return Row.new(
			depth + 1,
			start_slope,
			end_slope
		)
	
	func round_ties_up(n: float) -> float:
		return floor(n + 0.5)
	func round_ties_down(n: float) -> float:
		return floor(n - 0.5)

class Fraction:
	var x: float
	var y: float
	
	func _init(_x: float, _y: float):
		x = _x
		y = _y
	
	func toFloat() -> float:
		return x / y
