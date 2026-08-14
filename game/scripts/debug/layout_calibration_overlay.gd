extends Control

const RoomLayout = preload("res://game/data/room_layout.gd")

var _built: bool = false


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false
	_build_overlay()


func set_enabled(enabled: bool) -> void:
	visible = enabled


func is_enabled() -> bool:
	return visible


func _build_overlay() -> void:
	if _built:
		return
	_built = true

	_add_zone("HUD SAFE", RoomLayout.HUD_SAFE_ZONE, Color(0.35, 0.65, 1.0, 0.16))
	_add_zone("RIGHT UI SAFE", RoomLayout.RIGHT_CONTROLS_SAFE_ZONE, Color(0.75, 0.55, 1.0, 0.14))
	_add_zone("ACTIVE FLOOR", RoomLayout.ACTIVE_GAMEPLAY_FLOOR, Color(0.4, 0.8, 0.55, 0.12))
	_add_zone("AREA 2 RESERVE", RoomLayout.AREA2_RESERVE, Color(1.0, 0.65, 0.35, 0.15))
	_add_zone("LUMIE MOVE", RoomLayout.LUMIE_MOVEMENT_BOUNDS, Color(1.0, 0.85, 0.35, 0.16))

	for item_id in RoomLayout.FURNITURE_RECTS.keys():
		var rect: Rect2 = RoomLayout.get_furniture_rect(item_id)
		_add_zone("ANCHOR: %s" % String(item_id), rect, Color(0.9, 0.4, 0.55, 0.12))
		_add_anchor_marker(RoomLayout.get_furniture_anchor(item_id), String(item_id))

	var title := Label.new()
	title.text = "M7.1 ROOM LAYOUT CALIBRATION — DEBUG ONLY"
	title.position = Vector2(210.0, 1810.0)
	title.size = Vector2(660.0, 52.0)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.35, 0.24, 0.2, 1.0))
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(title)


func _add_zone(label_text: String, rect: Rect2, color: Color) -> void:
	var zone := ColorRect.new()
	zone.position = rect.position
	zone.size = rect.size
	zone.color = color
	zone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(zone)

	var label := Label.new()
	label.text = label_text
	label.position = Vector2(8.0, 6.0)
	label.size = Vector2(maxf(120.0, rect.size.x - 16.0), 34.0)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.25, 0.18, 0.15, 0.95))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	zone.add_child(label)


func _add_anchor_marker(point: Vector2, item_id: String) -> void:
	var marker := ColorRect.new()
	marker.position = point - Vector2(5.0, 5.0)
	marker.size = Vector2(10.0, 10.0)
	marker.color = Color(0.8, 0.2, 0.35, 0.9)
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(marker)

	var label := Label.new()
	label.text = item_id
	label.position = point + Vector2(8.0, -12.0)
	label.size = Vector2(180.0, 32.0)
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.35, 0.15, 0.2, 1.0))
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
