extends Node

class_name MapHandler

@onready var game: Game = $".."

@onready var path_handler: PathHandler = $"../path_handler"

@onready var floor_layer: TileMapLayer = $"../world/map/floor_layer"
@onready var object_layer: TileMapLayer = $"../world/map/object_layer"

func is_seethrough(coords: Vector2i) -> bool:
	var tiledata := object_layer.get_cell_tile_data(coords)
	return tiledata.get_custom_data("is_seethrough") if tiledata else true

func is_passible(coords: Vector2i) -> bool:
	var floor_tiledata := floor_layer.get_cell_tile_data(coords)
	var object_tiledata := object_layer.get_cell_tile_data(coords)
	
	var object_passible: bool = object_tiledata.get_custom_data("is_passible") if object_tiledata else true
	
	return floor_tiledata and object_passible

func get_interaction(coords: Vector2i) -> String:
	var tile_data := object_layer.get_cell_tile_data(coords)
	return tile_data.get_custom_data("interaction") if tile_data else ""

func get_investigation(coords: Vector2i) -> String:
	var tile_data := object_layer.get_cell_tile_data(coords)
	return tile_data.get_custom_data("investigation") if tile_data else ""

func interact(coords: Vector2i) -> void:
	var type: String = get_interaction(coords)
	if type == "":
		return
	
	match type:
		"CLOSED_DOOR":
			object_layer.set_cell(coords, 0, object_layer.get_cell_atlas_coords(coords) + Vector2i(1, 0))
			path_handler.update_tile(coords)
		"OPENED_DOOR":
			object_layer.set_cell(coords, 0, object_layer.get_cell_atlas_coords(coords) + Vector2i(-1, 0))
			path_handler.update_tile(coords)

func investigate(coords: Vector2i) -> void:
	var type: String = get_investigation(coords)
	if type == "":
		return
	
	match type:
		"SECRET_ENTRANCE":
			object_layer.set_cell(coords, 0, object_layer.get_cell_atlas_coords(coords) + Vector2i(1, 0))
			path_handler.update_tile(coords)
