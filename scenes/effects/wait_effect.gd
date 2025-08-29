extends Sprite2D

class_name WaitEffect

var coords: Vector2i

func _init(coords: Vector2i) -> void:
	self.coords = coords

func _enter_tree() -> void:
	texture = load("res://data/other/clock.png")
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	position = coords * Global.TILE_SIZE + Vector2i(16, 16)
	scale = Vector2(2.0, 2.0)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(self.queue_free)
