extends Node

class_name TurnHandler

signal turn(turn_number: int)

var turn_number: int = 0

func next_turn() -> void:
	turn_number += 1
	turn.emit(turn_number)
