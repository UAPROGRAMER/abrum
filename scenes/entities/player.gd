extends Entity

class_name Player

class Action:
	var end_turn: int
	func _init(end_turn: int) -> void:
		self.end_turn = end_turn

class ActionMoveTo extends Action:
	var coords: Vector2i
	func _init(end_turn: int, coords: Vector2i) -> void:
		super(end_turn)
		self.coords = coords

@onready var movement_component: MovementComponent = $movement_component

var action: Action = null

func move_to(new_coords: Vector2i) -> void:
	action = ActionMoveTo.new(game.turn_handler.turn + 4, new_coords)

func take_turn(turn: int) -> void:
	if action == null or action.end_turn != turn:
		return
	
	if action is ActionMoveTo:
		movement_component.move_to((action as ActionMoveTo).coords)
		action = null
		Global.move = true
