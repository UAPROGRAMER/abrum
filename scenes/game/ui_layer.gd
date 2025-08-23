extends CanvasLayer

@onready var game: Game = $".."

func change_ui_scale(scale: int) -> void:
	$bottom_container.size.y = 64 * scale
	$bottom_container.position.y -= 64 * (scale / 2)
	$bottom_container/wait_button.custom_minimum_size = Vector2i(64 * scale, 64 * scale)
	$bottom_container/game_speed_button.custom_minimum_size = Vector2i(64 * scale, 64 * scale)
	$menu_button.size = Vector2i(64 * scale, 64 * scale)
	$menu_button.position -= Vector2(64 * (scale / 2), 0)
	$menu.scale = Vector2i(scale * 2, scale * 2)

func _on_wait_button_pressed() -> void:
	game.player_handler.wait()

func _on_game_speed_button_pressed() -> void:
	const textures: Dictionary[int, AtlasTexture] = {
		1: preload("res://resources/textures/buttons/game_speed_1.tres"),
		2: preload("res://resources/textures/buttons/game_speed_2.tres"),
		4: preload("res://resources/textures/buttons/game_speed_4.tres")
	}
	
	const textures_p: Dictionary[int, AtlasTexture] = {
		1: preload("res://resources/textures/buttons/game_speed_1_p.tres"),
		2: preload("res://resources/textures/buttons/game_speed_2_p.tres"),
		4: preload("res://resources/textures/buttons/game_speed_4_p.tres")
	}
	
	if Global.game_speed == 1:
		Global.game_speed = 2
		$bottom_container/game_speed_button.texture_normal = textures[2]
		$bottom_container/game_speed_button.texture_pressed = textures_p[2]
	elif Global.game_speed == 2:
		Global.game_speed = 4
		$bottom_container/game_speed_button.texture_normal = textures[4]
		$bottom_container/game_speed_button.texture_pressed = textures_p[4]
	else:
		Global.game_speed = 1
		$bottom_container/game_speed_button.texture_normal = textures[1]
		$bottom_container/game_speed_button.texture_pressed = textures_p[1]

func _on_menu_button_pressed() -> void:
	get_tree().paused = true
	$menu_bg.visible = true
	$menu.visible = true

func _on_return_button_pressed() -> void:
	get_tree().paused = false
	$menu_bg.visible = false
	$menu.visible = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()
