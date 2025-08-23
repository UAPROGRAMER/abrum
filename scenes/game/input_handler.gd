extends Node

class_name InputHandler

@onready var game: Game = $".."

var is_press: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture:
		is_press = false
		zoom_event(event.factor)
	elif event.is_action_pressed("ZoomIn"):
		is_press = false
		zoom_event(1.05)
	elif event.is_action_pressed("ZoomOut"):
		is_press = false
		zoom_event(1.0/1.05)
	elif event is InputEventScreenDrag:
		is_press = false
		drag_event(event.relative)
	elif event is InputEventScreenTouch:
		if event.pressed:
			if event.index == 0:
				is_press = true
			else:
				is_press = false
		else:
			if is_press:
				press_event()

func zoom_event(factor: float) -> void:
	game.camera.change_zoom(factor)

func drag_event(relative: Vector2) -> void:
	game.camera.position -= relative / game.camera.zoom

func press_event() -> void:
	game.player_handler.move_to(
		game.tilemap.local_to_map(game.tilemap.get_local_mouse_position())
	)
