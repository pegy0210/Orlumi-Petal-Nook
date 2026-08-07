extends Node


func _ready() -> void:
	SaveService.load_progress()
	EconomyService.recalculate()
	OfflineService.prepare_pending_reward()
	EconomyService.start_runtime()
	get_tree().change_scene_to_file("res://game/scenes/main_room/main_room.tscn")
