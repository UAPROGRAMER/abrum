extends Node

class_name PlayerHandler

@onready var game: Game = $".."
@onready var player: Player = $"../world/player"

var path: Array[Vector2i]
var active: bool = false

var call_id: int = 0

func move_to(destination: Vector2i) -> void:
	call_id += 1
	var this_id = call_id
	
	path = game.tilemap_handler.get_id_path(player.coords, destination)
	for path_id: Vector2i in path:
		await get_tree().create_timer(0.1).timeout
		if this_id != call_id:
			return
		player.move(path_id - player.coords)
		while player.action != null:
			game.turn_handler.next_turn()
