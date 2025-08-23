extends Resource

class_name TileDataResource

var atlas_coords: Vector2i
var is_passible: bool

func _init(atlas_coords: Vector2i, is_passible: bool) -> void:
	self.atlas_coords = atlas_coords
	self.is_passible = is_passible
