extends Node

class_name PlayerHandler

@export var player: Player

@onready var map_handler: MapHandler = $"../map_handler"
@onready var path_handler: PathHandler = $"../path_handler"
@onready var turn_handler: TurnHandler = $"../turn_handler"

@onready var game: Game = $".."

var call_id: int = 0
var active: bool = false

func wait() -> void:
	if active:
		call_id += 1
		return
	
	var id: int = 0
	turn_handler.next_turn()
	while Global.change == false and id < 24:
		turn_handler.next_turn()
		id += 1

func move_to(destination: Vector2i) -> void:
	if not player:
		return
	
	call_id += 1
	var this_id = call_id
	active = true
	player.action = null
	
	if not path_handler.pathfinder.is_in_boundsv(destination) or destination == player.coords:
		active = false
		return
	
	var path = path_handler.pathfinder.get_id_path(player.coords, destination)
	path.pop_front()
	
	while path.size() > 0:
		if map_handler.is_passible(path.front()):
			player.move_to(path.front())
		else:
			player.interact(path.front())
		
		while player.action != null:
			turn_handler.next_turn()
			
			await get_tree().create_timer(0.06 / float(Global.game_speed)).timeout
			while get_tree().paused:
				await get_tree().process_frame
			
			if this_id != call_id:
				return
		
		path = path_handler.pathfinder.get_id_path(player.coords, destination)
		path.pop_front()
	
	active = false
