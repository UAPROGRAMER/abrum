extends Entity

class_name Ork

const directions: Array[Vector2i] = [
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.UP
]

@onready var movement_component: MovementComponent = $movement_component

var counter: int = 0

var direction: Vector2i = directions[0]

func take_turn(turn: int) -> void:
	if turn % 5 == 0:
		movement_component.move_to(coords + direction)
		counter += 1
		direction = directions[counter % 4]
