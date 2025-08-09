extends Node

class_name InputHandler

signal zoom_event(factor: float)
signal drag_event(relative: Vector2)
signal press_event()

@onready var game: Game = $".."

@onready var camera: Camera2D = $"../world/camera"
@onready var player: Player = $"../world/player"
@onready var tilemap: TileMapLayer = $"../world/tilemap"

const PRESS_SENC: int = 100

var is_press: bool = false

func _ready() -> void:
	zoom_event.connect(on_zoom_event)
	drag_event.connect(on_drag_event)
	press_event.connect(on_press_event)

func _input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture:
		is_press = false
		zoom_event.emit(event.factor)
	elif event.is_action_pressed("ZoomIn"):
		is_press = false
		zoom_event.emit(1.05)
	elif event.is_action_pressed("ZoomOut"):
		is_press = false
		zoom_event.emit(1.0/1.05)
	elif event is InputEventScreenDrag:
		is_press = false
		drag_event.emit(event.relative)
	elif event is InputEventScreenTouch:
		if event.pressed:
			if event.index == 0:
				is_press = true
			else:
				is_press = false
		else:
			if is_press:
				press_event.emit()

func on_zoom_event(factor: float) -> void:
	var real_factor: float = camera.zoom.x * factor
	real_factor = max(real_factor, 1.0)
	real_factor = min(real_factor, 4.0)
	camera.zoom = Vector2(real_factor, real_factor)

func on_drag_event(relative: Vector2) -> void:
	camera.position -= relative / camera.zoom

func on_press_event() -> void:
	game.player_handler.move_to(tilemap.local_to_map(tilemap.get_local_mouse_position()))
