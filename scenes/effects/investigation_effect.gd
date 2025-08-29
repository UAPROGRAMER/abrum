extends Polygon2D

class_name InvestigationEffect

var coords: Vector2i

func _init(coords: Vector2i) -> void:
	self.coords = coords

func _enter_tree() -> void:
	color = Color(0.39, 0.529, 0.65, 0.494)
	polygon = [
		Vector2(-8, -8),
		Vector2(8, -8),
		Vector2(8, 8),
		Vector2(-8, 8)
	]
	position = coords * Global.TILE_SIZE + Vector2i(16, 16)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(self.queue_free)
