extends Control

signal tapped

const RoomLayout = preload("res://game/data/room_layout.gd")

@export var item_id: String = ""
@export var fallback_name: String = "Furniture"
@export var interactive: bool = false

@onready var image: TextureRect = $Image
@onready var fallback_label: Label = $FallbackLabel
@onready var hit_button: Button = $HitButton

var _interaction_enabled: bool = true


func _ready() -> void:
	hit_button.pressed.connect(_on_pressed)
	GameState.state_changed.connect(refresh)
	refresh()


func refresh() -> void:
	_apply_dynamic_layout_if_needed()
	var level := _get_level()
	visible = level > 0
	if not visible:
		return

	var texture := VisualAssetService.get_furniture_texture(item_id, level)
	image.texture = texture
	image.visible = texture != null
	fallback_label.visible = texture == null
	fallback_label.text = "%s\nLv.%d" % [fallback_name, level]
	hit_button.visible = interactive
	hit_button.disabled = not interactive or not _interaction_enabled


func _apply_dynamic_layout_if_needed() -> void:
	if item_id != "little_pot":
		return
	var rect := RoomLayout.get_little_pot_rect(GameState.small_table_level > 0)
	position = rect.position
	size = rect.size


func set_interaction_enabled(enabled: bool) -> void:
	_interaction_enabled = enabled
	if is_node_ready():
		hit_button.disabled = not interactive or not enabled


func has_approved_texture() -> bool:
	return image.texture != null


func _on_pressed() -> void:
	if interactive and _interaction_enabled:
		tapped.emit()


func _get_level() -> int:
	match item_id:
		"little_pot": return GameState.little_pot_level
		"wooden_rack": return GameState.wooden_rack_level
		"curtain": return GameState.curtain_level
		"small_table": return GameState.small_table_level
	return 0
