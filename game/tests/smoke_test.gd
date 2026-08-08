extends Node

var failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	EconomyService.stop_runtime()
	OfflineService.clear_pending_reward()
	GameState.reset_to_defaults()
	EconomyService.recalculate()

	_check(GameState.petals == 0.0, "Default Petals should be 0")
	_check(GameState.little_pot_level == 1, "Little Pot should start at Lv1")
	_check(GameState.final_income_per_sec == 1.0, "Default income should be 1/sec")
	_check(GameState.comfort == 2, "Default Comfort should be 2")
	_check(not GameState.lumie_unlocked, "Lumie should start locked")

	GameState.petals = 30.0
	var bought_pot := EconomyService.purchase_or_upgrade("little_pot")
	_check(bought_pot, "Little Pot Lv1→Lv2 should purchase with 30 Petals")
	_check(GameState.petals == 0.0, "Little Pot Lv2 purchase should deduct 30 Petals")
	_check(GameState.little_pot_level == 2, "Little Pot should become Lv2")
	_check(GameState.final_income_per_sec == 2.0, "Little Pot Lv2 should produce 2/sec")
	_check(GameState.comfort == 4, "Little Pot Lv2 should give Comfort 4")
	_check(GameState.lumie_unlocked, "First real upgrade should unlock Lumie")

	GameState.petals = 42.0
	_check(SaveService.save_progress(), "Save should succeed")
	GameState.petals = 999.0
	_check(SaveService.load_progress(), "Load should succeed")
	EconomyService.recalculate()
	_check(GameState.petals == 42.0, "Load should restore saved Petals")
	_check(GameState.little_pot_level == 2, "Load should restore furniture level")
	_check(GameState.lumie_unlocked, "Load/recalculate should restore Lumie unlock")

	GameState.offline_cap_minutes = 60
	_check(OfflineService.increase_cap_after_rewarded_ad(), "60→75 offline cap should succeed")
	_check(OfflineService.increase_cap_after_rewarded_ad(), "75→90 offline cap should succeed")
	_check(OfflineService.increase_cap_after_rewarded_ad(), "90→105 offline cap should succeed")
	_check(OfflineService.increase_cap_after_rewarded_ad(), "105→120 offline cap should succeed")
	_check(GameState.offline_cap_minutes == 120, "Offline cap should stop at 120")
	_check(not OfflineService.increase_cap_after_rewarded_ad(), "Offline cap must not exceed 120")

	var main_room_scene := load("res://game/scenes/main_room/main_room.tscn")
	_check(main_room_scene != null, "MainRoom scene should load")
	if main_room_scene != null:
		var main_room_instance = main_room_scene.instantiate()
		_check(main_room_instance != null, "MainRoom scene should instantiate")
		if main_room_instance != null:
			main_room_instance.queue_free()

	SaveService.reset_progress()
	_check(GameState.petals == 0.0, "Reset should clear Petals")
	_check(GameState.little_pot_level == 1, "Reset should restore Little Pot Lv1")
	_check(GameState.offline_cap_minutes == 60, "Reset should restore 60-minute offline cap")
	_check(not GameState.lumie_unlocked, "Reset should lock Lumie")
	_check(not GameState.intro_played, "Reset should allow opening to replay")

	if failures.is_empty():
		print("PETAL_NOOK_SMOKE_TEST: PASS")
		get_tree().quit(0)
		return

	for failure in failures:
		push_error("PETAL_NOOK_SMOKE_TEST: %s" % failure)
	get_tree().quit(1)


func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
