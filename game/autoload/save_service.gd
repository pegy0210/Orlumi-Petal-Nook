extends Node

const SAVE_PATH := "user://petal_nook_save.json"
const AUTOSAVE_SECONDS := 60.0

var _autosave_elapsed: float = 0.0


func _process(delta: float) -> void:
	if not EconomyService.runtime_enabled:
		return
	_autosave_elapsed += delta
	if _autosave_elapsed >= AUTOSAVE_SECONDS:
		_autosave_elapsed = 0.0
		save_progress()


func save_progress() -> bool:
	GameState.last_save_unix = int(Time.get_unix_time_from_system())
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Could not open Petal Nook save file for writing.")
		return false
	file.store_string(JSON.stringify(GameState.to_save_dict()))
	file.close()
	return true


func load_progress() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		GameState.reset_to_defaults()
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		GameState.reset_to_defaults()
		return false

	var raw := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(raw)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Invalid save data; defaults restored.")
		GameState.reset_to_defaults()
		return false

	GameState.apply_save_dict(parsed)
	return true


func reset_progress() -> void:
	GameState.reset_to_defaults()
	EconomyService.recalculate()
	save_progress()
