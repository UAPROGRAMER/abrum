extends Node2D

class_name Player

const SPEED: int = 100

@onready var game: Game = get_tree().root.get_node("game")

@export var coords: Vector2i:
	set(new_coords):
		coords = new_coords
		position = coords * 16

var action: Action = null

class Action:
	var action_end: int
	func _init(action_end: int) -> void:
		self.action_end = action_end

class ActionMove extends Action:
	var delta: Vector2i
	func _init(action_end: int, delta: Vector2i) -> void:
		super._init(action_end)
		self.delta = delta

func _ready() -> void:
	await get_tree().process_frame
	game.turn_handler.turn.connect(on_turn)

func move(delta: Vector2i) -> void:
	action = ActionMove.new(game.turn_handler.turn_number + SPEED, delta)

func on_turn(turn_number: int) -> void:
	if action.action_end == turn_number:
		if action is ActionMove:
			coords += action.delta
		action = null
