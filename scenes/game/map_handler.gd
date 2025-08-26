extends Node

class_name MapHandler

@onready var game: Game = $".."

@onready var path_handler: PathHandler = $"../path_handler"

@onready var floor_layer: TileMapLayer = $"../world/map/floor_layer"
@onready var object_layer: TileMapLayer = $"../world/map/object_layer"

func is_seethrough(coords: Vector2i) -> bool:
	var tiledata := object_layer.get_cell_tile_data(coords)
	return tiledata.get_custom_data("seethrough") if tiledata else true

func is_passible(coords: Vector2i) -> bool:
	var floor_tiledata := floor_layer.get_cell_tile_data(coords)
	var object_tiledata := object_layer.get_cell_tile_data(coords)
	
	var floor_passible: bool = floor_tiledata.get_custom_data("passible") if floor_layer else false
	var object_passible: bool = object_tiledata.get_custom_data("passible") if object_tiledata else true
	
	return floor_passible and object_passible

func is_pathfindable(coords: Vector2i) -> bool:
	var floor_tiledata := floor_layer.get_cell_tile_data(coords)
	var object_tiledata := object_layer.get_cell_tile_data(coords)
	
	var floor_passible: bool = floor_tiledata.get_custom_data("pathfindable") if floor_layer else false
	var object_passible: bool = object_tiledata.get_custom_data("pathfindable") if object_tiledata else true
	
	return floor_passible and object_passible

func get_special(coords: Vector2i) -> String:
	var tile_data := object_layer.get_cell_tile_data(coords)
	return tile_data.get_custom_data("special") if tile_data else ""

func interact(coords: Vector2i) -> void:
	var special: String = get_special(coords)
	if special == "":
		return
	
	match special:
		"CLOSED_DOOR":
			object_layer.set_cell(coords, 0, Vector2i(1, 5))
			path_handler.update_tile(coords)
		"OPENED_DOOR":
			object_layer.set_cell(coords, 0, Vector2i(0, 5))
			path_handler.update_tile(coords)
