extends Panel

signal close_requested

@onready var close_button: Button = $Content/TopBar/Close
@onready var little_pot_card: Panel = $Content/Grid/LittlePotCard
@onready var wooden_rack_card: Panel = $Content/Grid/WoodenRackCard
@onready var curtain_card: Panel = $Content/Grid/CurtainCard
@onready var small_table_card: Panel = $Content/Grid/SmallTableCard


func _ready() -> void:
	visible = false
	close_button.pressed.connect(close_panel)
	little_pot_card.get_node("Upgrade").pressed.connect(_purchase.bind("little_pot"))
	wooden_rack_card.get_node("Upgrade").pressed.connect(_purchase.bind("wooden_rack"))
	curtain_card.get_node("Upgrade").pressed.connect(_purchase.bind("curtain"))
	small_table_card.get_node("Upgrade").pressed.connect(_purchase.bind("small_table"))
	GameState.state_changed.connect(refresh)
	refresh()


func open_panel() -> void:
	visible = true
	refresh()


func close_panel() -> void:
	visible = false
	close_requested.emit()


func refresh() -> void:
	_refresh_card(little_pot_card, "little_pot")
	_refresh_card(wooden_rack_card, "wooden_rack")
	_refresh_card(curtain_card, "curtain")
	_refresh_card(small_table_card, "small_table")


func _purchase(item_id: String) -> void:
	EconomyService.purchase_or_upgrade(item_id)


func _refresh_card(card: Panel, item_id: String) -> void:
	var level := _get_level(item_id)
	var level_label: Label = card.get_node("Level")
	var next_label: Label = card.get_node("Next")
	var price_label: Label = card.get_node("Price")
	var upgrade_button: Button = card.get_node("Upgrade")

	level_label.text = "Lv.%d" % level
	if level >= 5:
		next_label.text = "Fully awakened"
		price_label.text = "MAX"
		upgrade_button.text = "MAX"
		upgrade_button.disabled = true
		return

	var next_level := level + 1
	var cost := EconomyService.get_next_cost(item_id)
	next_label.text = _get_next_effect_text(item_id, next_level)
	price_label.text = "%d Petals" % int(cost)
	upgrade_button.text = "Upgrade"
	upgrade_button.disabled = GameState.petals < cost


func _get_level(item_id: String) -> int:
	match item_id:
		"little_pot": return GameState.little_pot_level
		"wooden_rack": return GameState.wooden_rack_level
		"curtain": return GameState.curtain_level
		"small_table": return GameState.small_table_level
	return -1


func _get_next_effect_text(item_id: String, next_level: int) -> String:
	match item_id:
		"little_pot":
			var data: Dictionary = EconomyService.LITTLE_POT[next_level]
			var text := "Next: %.0f/sec" % float(data["income"])
			if float(data["tap_bonus"]) > 0.0 and next_level == 3:
				text += " • Tap +1"
			return text
		"wooden_rack":
			var data: Dictionary = EconomyService.WOODEN_RACK[next_level]
			return "Next: +%.0f/sec" % float(data["income"])
		"curtain":
			var data: Dictionary = EconomyService.CURTAIN[next_level]
			return "Next: +%.0f%% income" % float(data["bonus"])
		"small_table":
			var data: Dictionary = EconomyService.SMALL_TABLE[next_level]
			return "Next: +%.0f%% income" % float(data["bonus"])
	return "Next"
