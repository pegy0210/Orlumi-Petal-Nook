extends Node

# Approved production art is resolved by convention instead of hard-coded
# preloads. Missing files are valid during development and fall back to
# developer visuals without breaking gameplay or CI.

var _texture_cache: Dictionary = {}


func get_main_room_background() -> Texture2D:
	return _load_texture("res://assets/backgrounds/main_room/bg_room_main.png")


func get_area2_locked_texture() -> Texture2D:
	return _load_texture("res://assets/backgrounds/main_room/area2_locked.png")


func get_furniture_texture(item_id: String, level: int) -> Texture2D:
	if level <= 0:
		return null
	var path := "res://assets/furniture/%s/%s_lv%d.png" % [item_id, item_id, level]
	return _load_texture(path)


func get_shop_icon(item_id: String) -> Texture2D:
	return _load_texture("res://assets/ui/shop_icons/%s.png" % item_id)


func get_companion_texture(companion_id: String, state_name: String) -> Texture2D:
	return _load_texture("res://assets/companions/%s/%s_%s.png" % [companion_id, companion_id, state_name])


func get_companion_shadow(companion_id: String) -> Texture2D:
	return _load_texture("res://assets/companions/%s/%s_shadow.png" % [companion_id, companion_id])


func get_photo_logo() -> Texture2D:
	return _load_texture("res://assets/logos/logo_orlumi_petal_nook.png")


func has_texture(path: String) -> bool:
	return ResourceLoader.exists(path)


func clear_cache() -> void:
	_texture_cache.clear()


func _load_texture(path: String) -> Texture2D:
	if _texture_cache.has(path):
		return _texture_cache[path] as Texture2D
	if not ResourceLoader.exists(path):
		return null
	var resource := ResourceLoader.load(path)
	if resource is Texture2D:
		_texture_cache[path] = resource
		return resource as Texture2D
	push_warning("Visual asset exists but is not a Texture2D: %s" % path)
	return null
