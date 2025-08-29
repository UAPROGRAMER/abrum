extends Node

class_name Game

@onready var map_handler    : MapHandler    = $map_handler
@onready var path_handler   : PathHandler   = $path_handler
@onready var fov_handler    : FovHandler    = $fov_handler
@onready var turn_handler   : TurnHandler   = $turn_handler
@onready var input_handler  : InputHandler  = $input_handler
@onready var player_handler : PlayerHandler = $player_handler

@onready var world: Node2D = $world

@onready var entities: Node2D = $world/entities

@onready var effects: Effects = $world/effects

@onready var camera: Camera = $world/camera

func _ready() -> void:
	await get_tree().process_frame
	$ui_layer.change_ui_scale(Global.get_ui_scale())
	fov_handler.setup()
	path_handler.setup()
	for entity: Entity in entities.get_children():
		entity.setup()
	camera.position = player_handler.player.position
	$background_layer.layer = -1
