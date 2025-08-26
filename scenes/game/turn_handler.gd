extends Node

class_name TurnHandler

@onready var game: Game = $".."

var turn: int = 0

func next_turn() -> void:
	Global.change = false
	turn += 1
	for entity: Entity in game.entities.get_children():
		entity.take_turn(turn)
