extends Node2D

class_name Game

@onready var input_handler: InputHandler = $input_handler
@onready var turn_handler: TurnHandler = $turn_handler
@onready var player_handler: PlayerHandler = $player_handler

@onready var tilemap: TileMapLayer = $tilemap
@onready var entities: Node2D = $entities
@onready var camera: Camera = $camera

const map_size: Vector2i = Vector2i(23, 23)

var map: Map
var pathfinder: AStarGrid2D

func _ready() -> void:
	await get_tree().process_frame
	create_level()
	setup_pathfinder()
	$ui_layer.change_ui_scale(Global.get_ui_scale())
	var player: Player = load("res://scenes/entities/player.tscn").instantiate()
	entities.add_child(player)
	player.coords = Vector2i(11, 11)
	player_handler.player = player
	var ork: Ork = load("res://scenes/entities/ork.tscn").instantiate()
	entities.add_child(ork)
	ork.coords = Vector2i(5, 5)

func create_level() -> void:
	map = Generator.generate_test_map(map_size)
	map.draw(tilemap)

func setup_pathfinder() -> void:
	pathfinder = AStarGrid2D.new()
	pathfinder.cell_size = Global.TILE_SIZE
	pathfinder.region = Rect2i(Vector2i.ZERO, map.size)
	pathfinder.update()
	
	for y in range(map.size.y):
		for x in range(map.size.x):
			pathfinder.set_point_solid(Vector2i(x, y), not Tiles.get_tile_data(map.get_tile(Vector2i(x, y))).is_passible)
