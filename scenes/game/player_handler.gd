extends Node

class_name PlayerHandler

@export var player: Player

@onready var game: Game = $".."

@onready var map_handler: MapHandler = $"../map_handler"
@onready var path_handler: PathHandler = $"../path_handler"
@onready var fov_handler: FovHandler = $"../fov_handler"
@onready var turn_handler: TurnHandler = $"../turn_handler"

@onready var effects: Effects = $"../world/effects"

var call_id: int = 0
var active: bool = false

func wait() -> void:
	if active:
		call_id += 1
	
	turn_handler.next_turn()
	effects.add_wait_effect(player.coords)
	
	fov_handler.compute_fov(player.coords, 20)

func investigate() -> void:
	const AROUND_VECTORS: Array[Vector2i] = [
		Vector2i(-1, -1),
		Vector2i(0, -1),
		Vector2i(1, -1),
		Vector2i(-1, 0),
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(-1, 1),
		Vector2i(0, 1),
		Vector2i(1, 1)
	]
	
	if active:
		call_id += 1
	
	turn_handler.next_turn()
	
	for vec: Vector2i in AROUND_VECTORS:
		map_handler.investigate(player.coords + vec)
		effects.add_investigation_effect(player.coords + vec)
	
	fov_handler.compute_fov(player.coords, 20)

func goal(destination: Vector2i) -> void:
	if not player:
		return
	
	call_id += 1
	var this_id = call_id
	active = true
	
	if not path_handler.pathfinder.is_in_boundsv(destination) or destination == player.coords:
		active = false
		return
	
	if not map_handler.is_passible(destination) and map_handler.get_interaction(destination) != "":
		path_handler.pathfinder.set_point_solid(destination, false)
		var path: Array[Vector2i] = path_handler.pathfinder.get_id_path(player.coords, destination)
		path_handler.update_tile(destination)
		
		if path.size() < 2:
			active = false
			return
		
		var near_destination: Vector2i = path[-2]
		
		path = path_handler.pathfinder.get_id_path(player.coords, near_destination)
		
		while path.size() > 1:
			player.move_to(path.get(1))
			
			while player.action != null:
				turn_handler.next_turn()
				
				await get_tree().create_timer(0.06 / float(Global.game_speed)).timeout
				while get_tree().paused:
					await get_tree().process_frame
				
				if this_id != call_id:
					return
			
			path = path_handler.pathfinder.get_id_path(player.coords, near_destination)
		
		player.interact(destination)
		
		while player.action != null:
			turn_handler.next_turn()
			
			await get_tree().create_timer(0.06 / float(Global.game_speed)).timeout
			while get_tree().paused:
				await get_tree().process_frame
			
			if this_id != call_id:
				return
	else:
		var path: Array[Vector2i] = path_handler.pathfinder.get_id_path(player.coords, destination)
		
		while path.size() > 1:
			player.move_to(path.get(1))
			
			while player.action != null:
				turn_handler.next_turn()
				
				await get_tree().create_timer(0.06 / float(Global.game_speed)).timeout
				while get_tree().paused:
					await get_tree().process_frame
				
				if this_id != call_id:
					return
			
			path = path_handler.pathfinder.get_id_path(player.coords, destination)
	
	active = false
