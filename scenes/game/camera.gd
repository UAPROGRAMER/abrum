extends Camera2D

class_name Camera

var real_factor: float = 2

func change_zoom(factor: float) -> void:
	real_factor *= factor
	real_factor = max(real_factor, 1.0)
	real_factor = min(real_factor, 4.0)
	var zoom_factor = round(real_factor * 10.0) / 10.0
	zoom = Vector2(zoom_factor, zoom_factor)
