extends Control

signal exit_requested
signal capture_saved(path: String)
signal capture_failed

@onready var logo_texture: TextureRect = $LogoTexture
@onready var logo_fallback: Label = $LogoFallback
@onready var capture_button: Button = $Capture
@onready var exit_button: Button = $Exit

var capture_in_progress: bool = false


func _ready() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	capture_button.pressed.connect(_on_capture_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	_refresh_logo()


func _refresh_logo() -> void:
	var texture := VisualAssetService.get_photo_logo()
	logo_texture.texture = texture
	logo_texture.visible = texture != null
	logo_fallback.visible = texture == null


func open_mode() -> void:
	capture_in_progress = false
	capture_button.visible = true
	exit_button.visible = true
	_refresh_logo()
	logo_texture.visible = logo_texture.texture != null
	logo_fallback.visible = logo_texture.texture == null
	visible = true


func close_mode() -> void:
	if capture_in_progress:
		return
	visible = false


func _on_exit_pressed() -> void:
	if capture_in_progress:
		return
	exit_requested.emit()


func _on_capture_pressed() -> void:
	if capture_in_progress:
		return
	capture_in_progress = true
	capture_button.visible = false
	exit_button.visible = false

	# Wait until the frame with hidden controls has actually been drawn.
	await RenderingServer.frame_post_draw

	var image := get_viewport().get_texture().get_image()
	var timestamp := int(Time.get_unix_time_from_system())
	var path := "user://petal_nook_photo_%d.png" % timestamp
	var error := image.save_png(path)

	capture_button.visible = true
	exit_button.visible = true
	capture_in_progress = false

	if error == OK:
		capture_saved.emit(path)
	else:
		capture_failed.emit()
