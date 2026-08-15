extends Control

# Area 2 is deliberately separate from BgRoom.
# It stays fully hidden until a future progression/state rule explicitly enables it.

@onready var image: TextureRect = $Image

var _lock_visible: bool = false


func _ready() -> void:
	_refresh_texture()
	set_lock_visible(false)


func set_lock_visible(value: bool) -> void:
	_lock_visible = value
	visible = value


func is_lock_visible() -> bool:
	return _lock_visible


func _refresh_texture() -> void:
	var texture := VisualAssetService.get_area2_locked_texture()
	image.texture = texture
	image.visible = texture != null
