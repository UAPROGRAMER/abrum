extends Node

class_name Game

@onready var input_handler: InputHandler = $input_handler
@onready var turn_handler: TurnHandler = $turn_handler
@onready var tilemap_handler: TilemapHandler = $tilemap_handler
@onready var player_handler: PlayerHandler = $player_handler

@onready var world: Node2D = $world

@onready var camera: Camera = $world/camera
