extends Control

const OPENING_LINES: Array[String] = [
	"Somewhere within Orlumi,",
	"there is a little house.",
	"Inside, a flower waits in silence.",
	"This is where your nook begins."
]

const LUMIE_INTRO_LINES: Array[String] = [
	"With the first piece placed,",
	"the little house stirs softly.",
	"A tiny companion has drawn near.",
	"Its name is Lumie."
]

@onready var petals_label: Label = $ResourceUI/Petals
@onready var income_label: Label = $ResourceUI/Income
@onready var comfort_label: Label = $ResourceUI/Comfort
@onready var offline_cap_label: Label = $ResourceUI/OfflineCap
@onready var little_pot_button: Button = $LittlePotButton
@onready var lumie_placeholder: Label = $LumiePlaceholder
@onready var status_label: Label = $Status
@onready var save_button: Button = $SaveButton
@onready var shop_button: Button = $ShopButton
@onready var shop_panel: Panel = $ShopPanel
@onready var shop_close_button: Button = $ShopPanel/Close
@onready var pot_level_label: Label = $ShopPanel/LittlePotCard/Level
@onready var pot_next_label: Label = $ShopPanel/LittlePotCard/Next
@onready var pot_price_label: Label = $ShopPanel/LittlePotCard/Price
@onready var pot_upgrade_button: Button = $ShopPanel/LittlePotCard/Upgrade
@onready var offline_popup: Panel = $OfflinePopup
@onready var offline_reward_label: Label = $OfflinePopup/Reward
@onready var offline_claim_button: Button = $OfflinePopup/Claim
@onready var story_overlay = $StoryOverlay


func _ready() -> void:
	GameState.state_changed.connect(_refresh_ui)
	EconomyService.purchase_succeeded.connect(_on_purchase_succeeded)
	EconomyService.purchase_failed.connect(_on_purchase_failed)
	little_pot_button.pressed.connect(_on_little_pot_pressed)
	save_button.pressed.connect(_on_save_pressed)
	shop_button.pressed.connect(_on_shop_pressed)
	shop_close_button.pressed.connect(_on_shop_close_pressed)
	pot_upgrade_button.pressed.connect(_on_pot_upgrade_pressed)
	offline_claim_button.pressed.connect(_on_offline_claim_pressed)
	story_overlay.sequence_finished.connect(_on_story_sequence_finished)
	_refresh_ui()
	_prepare_offline_popup()
	call_deferred("_start_opening_if_needed")


func _refresh_ui() -> void:
	petals_label.text = "Petals: %d" % int(floor(GameState.petals))
	income_label.text = "Income: %.1f/s" % GameState.final_income_per_sec
	comfort_label.text = "Comfort: %d" % GameState.comfort
	offline_cap_label.text = "Offline Limit: %d min" % GameState.offline_cap_minutes
	lumie_placeholder.visible = GameState.lumie_unlocked

	var level := GameState.little_pot_level
	pot_level_label.text = "Lv.%d" % level
	if level >= 5:
		pot_next_label.text = "Fully awakened"
		pot_price_label.text = "MAX"
		pot_upgrade_button.text = "MAX"
		pot_upgrade_button.disabled = true
	else:
		var next_level := level + 1
		var next_data: Dictionary = EconomyService.LITTLE_POT[next_level]
		var cost := EconomyService.get_next_cost("little_pot")
		pot_next_label.text = "Next: %.0f/sec" % float(next_data["income"])
		pot_price_label.text = "%d Petals" % int(cost)
		pot_upgrade_button.text = "Upgrade"
		pot_upgrade_button.disabled = GameState.petals < cost


func _prepare_offline_popup() -> void:
	if OfflineService.pending_reward <= 0.0:
		offline_popup.visible = false
		return
	var minutes := int(ceil(float(OfflineService.pending_seconds) / 60.0))
	offline_reward_label.text = "%d min away\n+%d Petals" % [minutes, int(floor(OfflineService.pending_reward))]
	offline_popup.visible = true


func _start_opening_if_needed() -> void:
	if GameState.intro_played:
		return
	offline_popup.visible = false
	shop_panel.visible = false
	story_overlay.start_sequence("opening", OPENING_LINES)


func _start_lumie_intro_if_needed() -> void:
	if not GameState.lumie_unlocked or GameState.lumie_intro_played:
		return
	shop_panel.visible = false
	story_overlay.start_sequence("lumie_intro", LUMIE_INTRO_LINES)


func _on_little_pot_pressed() -> void:
	EconomyService.tap_little_pot()
	status_label.text = "+%d Petal" % int(GameState.tap_value)


func _on_save_pressed() -> void:
	if SaveService.save_progress():
		status_label.text = "Saved ✦"
	else:
		status_label.text = "Save failed"


func _on_shop_pressed() -> void:
	if story_overlay.is_sequence_active():
		return
	shop_panel.visible = true


func _on_shop_close_pressed() -> void:
	shop_panel.visible = false


func _on_pot_upgrade_pressed() -> void:
	EconomyService.purchase_or_upgrade("little_pot")


func _on_purchase_succeeded(item_id: String, new_level: int) -> void:
	if item_id == "little_pot":
		status_label.text = "Little Pot reached Lv.%d ✦" % new_level
	_refresh_ui()
	_start_lumie_intro_if_needed()


func _on_purchase_failed(_item_id: String, reason: String) -> void:
	match reason:
		"NOT_ENOUGH_PETALS": status_label.text = "Not enough Petals"
		"MAX_OR_INVALID": status_label.text = "Already at MAX"
		_: status_label.text = "Upgrade unavailable"


func _on_offline_claim_pressed() -> void:
	var amount := OfflineService.claim_pending_reward()
	status_label.text = "+%d offline Petals" % int(floor(amount))
	offline_popup.visible = false
	_refresh_ui()


func _on_story_sequence_finished(sequence_id: String) -> void:
	match sequence_id:
		"opening":
			GameState.intro_played = true
			SaveService.save_progress()
			GameState.state_changed.emit()
			_prepare_offline_popup()
		"lumie_intro":
			GameState.lumie_intro_played = true
			SaveService.save_progress()
			GameState.state_changed.emit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveService.save_progress()
