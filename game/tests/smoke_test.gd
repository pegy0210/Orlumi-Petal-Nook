extends Node

const RoomLayout = preload("res://game/data/room_layout.gd")
const FurnitureVisualContract = preload("res://game/data/furniture_visual_contract.gd")

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

	_check(RoomLayout.REFERENCE_VIEWPORT == Vector2(1080.0, 1920.0), "Room layout reference must remain 1080x1920")
	_check(RoomLayout.HUD_SAFE_ZONE.end.y < RoomLayout.ACTIVE_GAMEPLAY_FLOOR.position.y, "HUD safe zone should remain above the active floor")
	_check(RoomLayout.LUMIE_MOVEMENT_BOUNDS.end.x <= RoomLayout.AREA2_RESERVE.position.x, "Lumie movement must not enter Area 2 reserve")
	_check(RoomLayout.LUMIE_MOVEMENT_BOUNDS.size.x >= 650.0, "Layout A must preserve broad Lumie horizontal roaming")
	_check(RoomLayout.LUMIE_MOVEMENT_BOUNDS.size.y >= 650.0, "Layout A must preserve broad Lumie vertical roaming")
	for item_id in RoomLayout.FURNITURE_RECTS.keys():
		var rect: Rect2 = RoomLayout.get_furniture_rect(String(item_id))
		_check(RoomLayout.is_rect_inside_reference(rect), "%s layout rect must remain inside reference viewport" % String(item_id))

	_check(FurnitureVisualContract.get_asset_size("wooden_rack") == Vector2i(320, 420), "Wooden Rack asset contract must remain 320x420")
	_check(FurnitureVisualContract.get_asset_size("curtain") == Vector2i(360, 260), "Curtain asset contract must remain 360x260")
	_check(FurnitureVisualContract.get_asset_size("small_table") == Vector2i(300, 300), "Small Table asset contract must remain 300x300")
	_check(FurnitureVisualContract.has_complete_progression("wooden_rack"), "Wooden Rack must define Lv1-Lv5 visual progression")
	_check(FurnitureVisualContract.has_complete_progression("curtain"), "Curtain must define Lv1-Lv5 visual progression")
	_check(FurnitureVisualContract.has_complete_progression("small_table"), "Small Table must define Lv1-Lv5 visual progression")
	_check(FurnitureVisualContract.SMALL_TABLE_POT_CLEARANCE_DIAMETER >= 160, "Small Table Lv4/Lv5 must keep Little Pot clearance")

	var layout_overlay_scene := load("res://game/scenes/debug/layout_calibration_overlay.tscn")
	_check(layout_overlay_scene != null, "Layout calibration overlay should load")
	if layout_overlay_scene != null:
		var layout_overlay_instance = layout_overlay_scene.instantiate()
		_check(layout_overlay_instance != null, "Layout calibration overlay should instantiate")
		if layout_overlay_instance != null:
			layout_overlay_instance.queue_free()

	var main_room_scene := load("res://game/scenes/main_room/main_room.tscn")
	_check(main_room_scene != null, "MainRoom scene should load")
	if main_room_scene != null:
		var main_room_instance = main_room_scene.instantiate()
		_check(main_room_instance != null, "MainRoom scene should instantiate")
		if main_room_instance != null:
			_check(main_room_instance.has_node("Overlay/LayoutCalibrationOverlay"), "MainRoom should include layout calibration overlay")
			_check(main_room_instance.has_node("UI/ResourceUI/Petals"), "MainRoom should keep top-left Petals display")
			_check(main_room_instance.has_node("UI/ResourceUI/Income"), "MainRoom should keep top-left Income display")
			_check(main_room_instance.has_node("UI/ResourceUI/Comfort"), "MainRoom should keep top-left Comfort display")
			_check(main_room_instance.has_node("UI/ResourceUI/OfflineCap"), "MainRoom should keep top-left Offline Limit display")
			_check(main_room_instance.has_node("UI/SaveButton"), "MainRoom should keep Save control")
			_check(main_room_instance.has_node("UI/OfflineBoostButton"), "MainRoom should keep Offline Boost control")
			_check(main_room_instance.has_node("UI/ShopButton"), "MainRoom should keep Shop control")
			_check(main_room_instance.has_node("UI/SettingsButton"), "MainRoom should keep Settings control")
			_check(main_room_instance.has_node("UI/PhotoButton"), "MainRoom should keep Photo Mode control")
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
