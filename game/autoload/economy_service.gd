extends Node

signal economy_changed
signal purchase_succeeded(item_id: String, new_level: int)
signal purchase_failed(item_id: String, reason: String)

var runtime_enabled: bool = false

const LITTLE_POT := {
	1: {"income": 1.0, "tap_bonus": 0.0, "comfort": 2},
	2: {"income": 2.0, "tap_bonus": 0.0, "comfort": 4},
	3: {"income": 3.0, "tap_bonus": 1.0, "comfort": 7},
	4: {"income": 5.0, "tap_bonus": 1.0, "comfort": 10},
	5: {"income": 7.0, "tap_bonus": 1.0, "comfort": 14}
}
const LITTLE_POT_UPGRADE_COST := {1: 30.0, 2: 60.0, 3: 120.0, 4: 240.0}

const WOODEN_RACK := {
	0: {"income": 0.0, "comfort": 0},
	1: {"income": 1.0, "comfort": 4},
	2: {"income": 2.0, "comfort": 8},
	3: {"income": 4.0, "comfort": 13},
	4: {"income": 6.0, "comfort": 18},
	5: {"income": 9.0, "comfort": 24}
}
const WOODEN_RACK_COST := {0: 50.0, 1: 100.0, 2: 200.0, 3: 400.0, 4: 800.0}

const CURTAIN := {
	0: {"bonus": 0.0, "comfort": 0},
	1: {"bonus": 5.0, "comfort": 6},
	2: {"bonus": 10.0, "comfort": 12},
	3: {"bonus": 15.0, "comfort": 19},
	4: {"bonus": 22.0, "comfort": 26},
	5: {"bonus": 30.0, "comfort": 34}
}
const CURTAIN_COST := {0: 120.0, 1: 240.0, 2: 480.0, 3: 960.0, 4: 1920.0}

const SMALL_TABLE := {
	0: {"bonus": 0.0, "comfort": 0},
	1: {"bonus": 5.0, "comfort": 10},
	2: {"bonus": 8.0, "comfort": 20},
	3: {"bonus": 12.0, "comfort": 32},
	4: {"bonus": 16.0, "comfort": 44},
	5: {"bonus": 20.0, "comfort": 59}
}
const SMALL_TABLE_COST := {0: 300.0, 1: 600.0, 2: 1200.0, 3: 2400.0, 4: 4800.0}


func _process(delta: float) -> void:
	if not runtime_enabled:
		return
	GameState.petals += GameState.final_income_per_sec * delta
	GameState.state_changed.emit()


func start_runtime() -> void:
	runtime_enabled = true


func stop_runtime() -> void:
	runtime_enabled = false


func tap_little_pot() -> void:
	if not runtime_enabled:
		return
	GameState.petals += GameState.tap_value
	GameState.state_changed.emit()


func recalculate() -> void:
	var pot: Dictionary = LITTLE_POT[GameState.little_pot_level]
	var rack: Dictionary = WOODEN_RACK[GameState.wooden_rack_level]
	var curtain: Dictionary = CURTAIN[GameState.curtain_level]
	var table: Dictionary = SMALL_TABLE[GameState.small_table_level]

	GameState.base_income_per_sec = float(pot["income"]) + float(rack["income"])
	GameState.bonus_percent = float(curtain["bonus"]) + float(table["bonus"])
	GameState.final_income_per_sec = GameState.base_income_per_sec * (1.0 + GameState.bonus_percent / 100.0)
	GameState.tap_value = 1.0 + float(pot["tap_bonus"])
	GameState.comfort = int(pot["comfort"]) + int(rack["comfort"]) + int(curtain["comfort"]) + int(table["comfort"])
	GameState.area2_unlocked = GameState.comfort >= 20 and GameState.small_table_level >= 1
	GameState.lumie_unlocked = (
		GameState.little_pot_level >= 2
		or GameState.wooden_rack_level >= 1
		or GameState.curtain_level >= 1
		or GameState.small_table_level >= 1
	)
	GameState.state_changed.emit()
	economy_changed.emit()


func get_next_cost(item_id: String) -> float:
	match item_id:
		"little_pot":
			return float(LITTLE_POT_UPGRADE_COST.get(GameState.little_pot_level, -1.0))
		"wooden_rack":
			return float(WOODEN_RACK_COST.get(GameState.wooden_rack_level, -1.0))
		"curtain":
			return float(CURTAIN_COST.get(GameState.curtain_level, -1.0))
		"small_table":
			return float(SMALL_TABLE_COST.get(GameState.small_table_level, -1.0))
	return -1.0


func purchase_or_upgrade(item_id: String) -> bool:
	var current_level := _get_level(item_id)
	if current_level < 0 or current_level >= 5:
		purchase_failed.emit(item_id, "MAX_OR_INVALID")
		return false

	var cost := get_next_cost(item_id)
	if cost < 0.0:
		purchase_failed.emit(item_id, "NO_COST")
		return false
	if GameState.petals < cost:
		purchase_failed.emit(item_id, "NOT_ENOUGH_PETALS")
		return false

	GameState.petals -= cost
	_set_level(item_id, current_level + 1)
	recalculate()
	SaveService.save_progress()
	purchase_succeeded.emit(item_id, current_level + 1)
	return true


func _get_level(item_id: String) -> int:
	match item_id:
		"little_pot": return GameState.little_pot_level
		"wooden_rack": return GameState.wooden_rack_level
		"curtain": return GameState.curtain_level
		"small_table": return GameState.small_table_level
	return -1


func _set_level(item_id: String, value: int) -> void:
	match item_id:
		"little_pot": GameState.little_pot_level = value
		"wooden_rack": GameState.wooden_rack_level = value
		"curtain": GameState.curtain_level = value
		"small_table": GameState.small_table_level = value
