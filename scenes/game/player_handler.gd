extends Node

class_name PlayerHandler

@onready var game: Game = $".."
var player: Player = null

var path: Array[Vector2i]

var call_id: int = 0
var active: bool = false

func wait() -> void:
	if active:
		call_id += 1
		return
	
	var id: int = 0
	while Global.move == false and id < 25:
		game.turn_handler.next_turn()
		id += 1
	Global.move = false

func move_to(destination: Vector2i) -> void:
	if not player:
		return
	
	active = true
	call_id += 1
	var this_id = call_id
	
	if not game.pathfinder.is_in_boundsv(destination) or destination == player.coords:
		active = false
		return
	
	path = game.pathfinder.get_id_path(player.coords, destination)
	path.pop_front()
	
	for path_id: Vector2i in path:
		player.move_to(path_id)
		
		while player.action != null:
			game.turn_handler.next_turn()
			
			if Global.move:
				Global.move = false
			
			await get_tree().create_timer(0.06 / float(Global.game_speed)).timeout
			
			while get_tree().paused:
				await get_tree().process_frame
			
			if this_id != call_id:
				active = false
				player.action = null
				return
	
	active = false
