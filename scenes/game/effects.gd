extends Node2D

class_name Effects

func add_wait_effect(coords: Vector2i) -> void:
	var effect := WaitEffect.new(coords)
	add_child(effect)

func add_investigation_effect(coords: Vector2i) -> void:
	var effect := InvestigationEffect.new(coords)
	add_child(effect)
