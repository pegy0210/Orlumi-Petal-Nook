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
@onready var wooden_rack_placeholder: Label = $WoodenRackPlaceholder
@onready var curtain_placeholder: Label = $CurtainPlaceholder
@onready var small_table_placeholder: Label = $SmallTablePlaceholder
@onready var lumie = $Lumie
@onready var status_label: Label = $Status
@onready var save_button: Button = $SaveButton
@onready var shop_button: Button = $ShopButton
@onready var settings_button: Button = $SettingsButton
@onready var shop_panel = $ShopPanel
@onready var settings_panel = $SettingsPanel
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
	settings_button.pressed.connect(_on_settings_pressed)
	offline_claim_button.pressed.connect(_on_offline_claim_pressed)
	story_overlay.sequence_finished.connect(_on_story_sequence_finished)
	shop_panel.close_requested.connect(_on_modal_closed)
	settings_panel.close_requested.connect(_on_modal_closed)
	settings_panel.reset_completed.connect(_on_reset_completed)
	lumie.reaction_started.connect(_on_lumie_reaction_started)
	lumie.annoyed_started.connect(_on_lumie_annoyed_started)
	lumie.annoyed_ended.connect(_on_lumie_annoyed_ended)
	_refresh_ui()
	_prepare_offline_popup()
	_update_modal_input_state()
	call_deferred("_start_opening_if_needed")


func _refresh_ui() -> void:
	petals_label.text = "Petals: %d" % int(floor(GameState.petals))
	income_label.text = "Income: %.1f/s" % GameState.final_income_per_sec
	comfort_label.text = "Comfort: %d" % GameState.comfort
	offline_cap_label.text = "Offline Limit: %d min" % GameState.offline_cap_minutes
	wooden_rack_placeholder.visible = GameState.wooden_rack_level >= 1
	curtain_placeholder.visible = GameState.curtain_level >= 1
	small_table_placeholder.visible = GameState.small_table_level >= 1


func _prepare_offline_popup() -> void:
	if OfflineService.pending_reward <= 0.0:
		offline_popup.visible = false
		_update_modal_input_state()
		return
	var minutes := int(ceil(float(OfflineService.pending_seconds) / 60.0))
	offline_reward_label.text = "%d min away\n+%d Petals" % [minutes, int(floor(OfflineService.pending_reward))]
	offline_popup.visible = true
	_update_modal_input_state()


func _start_opening_if_needed() -> void:
	if GameState.intro_played:
		_update_modal_input_state()
		return
	offline_popup.visible = false
	shop_panel.visible = false
	settings_panel.visible = false
	story_overlay.start_sequence("opening", OPENING_LINES)
	_update_modal_input_state()


func _start_lumie_intro_if_needed() -> void:
	if not GameState.lumie_unlocked or GameState.lumie_intro_played:
		return
	shop_panel.visible = false
	settings_panel.visible = false
	story_overlay.start_sequence("lumie_intro", LUMIE_INTRO_LINES)
	_update_modal_input_state()


func _is_modal_open() -> bool:
	return story_overlay.is_sequence_active() or shop_panel.visible or settings_panel.visible or offline_popup.visible


func _update_modal_input_state() -> void:
	if not is_node_ready():
		return
	var blocked := _is_modal_open()
	little_pot_button.disabled = blocked
	save_button.disabled = blocked
	shop_button.disabled = blocked
	settings_button.disabled = blocked
	lumie.set_interaction_enabled(not blocked)


func _on_little_pot_pressed() -> void:
	if _is_modal_open():
		return
	EconomyService.tap_little_pot()
	status_label.text = "+%d Petal" % int(GameState.tap_value)


func _on_save_pressed() -> void:
	if _is_modal_open():
		return
	if SaveService.save_progress():
		status_label.text = "Saved ✦"
	else:
		status_label.text = "Save failed"


func _on_shop_pressed() -> void:
	if _is_modal_open():
		return
	settings_panel.visible = false
	shop_panel.open_panel()
	_update_modal_input_state()


func _on_settings_pressed() -> void:
	if _is_modal_open():
		return
	shop_panel.visible = false
	settings_panel.open_panel()
	_update_modal_input_state()


func _on_modal_closed() -> void:
	_update_modal_input_state()


func _on_purchase_succeeded(item_id: String, new_level: int) -> void:
	var item_name := _display_name_for_item(item_id)
	status_label.text = "%s reached Lv.%d ✦" % [item_name, new_level]
	_refresh_ui()
	_start_lumie_intro_if_needed()


func _on_purchase_failed(_item_id: String, reason: String) -> void:
	match reason:
		"NOT_ENOUGH_PETALS": status_label.text = "Not enough Petals"
		"MAX_OR_INVALID": status_label.text = "Already at MAX"
		_: status_label.text = "Upgrade unavailable"


func _on_offline_claim_pressed() -> void:
	if story_overlay.is_sequence_active() or shop_panel.visible or settings_panel.visible:
		return
	var amount := OfflineService.claim_pending_reward()
	status_label.text = "+%d offline Petals" % int(floor(amount))
	offline_popup.visible = false
	_refresh_ui()
	_update_modal_input_state()


func _on_reset_completed() -> void:
	shop_panel.visible = false
	settings_panel.visible = false
	offline_popup.visible = false
	status_label.text = ""
	_refresh_ui()
	_update_modal_input_state()
	call_deferred("_start_opening_if_needed")


func _on_lumie_reaction_started(emoji: String) -> void:
	status_label.text = "Lumie %s" % emoji


func _on_lumie_annoyed_started() -> void:
	status_label.text = "Lumie wants a little quiet..."


func _on_lumie_annoyed_ended() -> void:
	status_label.text = "Lumie feels better ✦"


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
	_update_modal_input_state()


func _display_name_for_item(item_id: String) -> String:
	match item_id:
		"little_pot": return "Little Pot"
		"wooden_rack": return "Wooden Rack"
		"curtain": return "Curtain"
		"small_table": return "Small Table"
	return "Furniture"


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveService.save_progress()
