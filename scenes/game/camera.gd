extends Camera2D

class_name Camera

@export var real_factor: float = 0.0

@onready var game: Game = $".."

func _ready() -> void:
	change_zoom(1.0)

func change_zoom(factor: float) -> void:
	real_factor *= factor
	real_factor = max(real_factor, 1.0)
	real_factor = min(real_factor, 4.0)
	var zoom_factor = real_factor
	zoom = Vector2(zoom_factor, zoom_factor)
