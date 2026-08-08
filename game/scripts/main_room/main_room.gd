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

@onready var background_fallback: ColorRect = $Base/BackgroundFallback
@onready var background_texture: TextureRect = $Base/BackgroundTexture
@onready var little_pot_visual = $Furniture/LittlePot
@onready var lumie = $Companions/Lumie
@onready var ui_layer: Control = $UI
@onready var petals_label: Label = $UI/ResourceUI/Petals
@onready var income_label: Label = $UI/ResourceUI/Income
@onready var comfort_label: Label = $UI/ResourceUI/Comfort
@onready var offline_cap_label: Label = $UI/ResourceUI/OfflineCap
@onready var status_label: Label = $UI/Status
@onready var save_button: Button = $UI/SaveButton
@onready var shop_button: Button = $UI/ShopButton
@onready var settings_button: Button = $UI/SettingsButton
@onready var offline_boost_button: Button = $UI/OfflineBoostButton
@onready var photo_button: Button = $UI/PhotoButton
@onready var shop_panel = $Overlay/ShopPanel
@onready var settings_panel = $Overlay/SettingsPanel
@onready var offline_popup: Panel = $Overlay/OfflinePopup
@onready var offline_reward_label: Label = $Overlay/OfflinePopup/Reward
@onready var offline_claim_button: Button = $Overlay/OfflinePopup/Claim
@onready var photo_mode_ui = $Overlay/PhotoModeUI
@onready var story_overlay = $Overlay/StoryOverlay

var photo_mode_active: bool = false
var _photo_result_message: String = ""


func _ready() -> void:
	GameState.state_changed.connect(_refresh_ui)
	EconomyService.purchase_succeeded.connect(_on_purchase_succeeded)
	EconomyService.purchase_failed.connect(_on_purchase_failed)
	RewardedAdService.reward_granted.connect(_on_rewarded_ad_granted)
	RewardedAdService.reward_unavailable.connect(_on_rewarded_ad_unavailable)
	little_pot_visual.tapped.connect(_on_little_pot_pressed)
	save_button.pressed.connect(_on_save_pressed)
	shop_button.pressed.connect(_on_shop_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	offline_boost_button.pressed.connect(_on_offline_boost_pressed)
	photo_button.pressed.connect(_on_photo_pressed)
	offline_claim_button.pressed.connect(_on_offline_claim_pressed)
	story_overlay.sequence_finished.connect(_on_story_sequence_finished)
	shop_panel.close_requested.connect(_on_modal_closed)
	settings_panel.close_requested.connect(_on_modal_closed)
	settings_panel.reset_completed.connect(_on_reset_completed)
	photo_mode_ui.exit_requested.connect(_on_photo_exit_requested)
	photo_mode_ui.capture_saved.connect(_on_photo_capture_saved)
	photo_mode_ui.capture_failed.connect(_on_photo_capture_failed)
	lumie.reaction_started.connect(_on_lumie_reaction_started)
	lumie.annoyed_started.connect(_on_lumie_annoyed_started)
	lumie.annoyed_ended.connect(_on_lumie_annoyed_ended)
	_refresh_visual_assets()
	_refresh_ui()
	_prepare_offline_popup()
	_update_modal_input_state()
	call_deferred("_start_opening_if_needed")


func _refresh_visual_assets() -> void:
	var room_texture := VisualAssetService.get_main_room_background()
	background_texture.texture = room_texture
	background_texture.visible = room_texture != null
	background_fallback.visible = room_texture == null


func _refresh_ui() -> void:
	petals_label.text = "Petals: %d" % int(floor(GameState.petals))
	income_label.text = "Income: %.1f/s" % GameState.final_income_per_sec
	comfort_label.text = "Comfort: %d" % GameState.comfort
	offline_cap_label.text = "Offline Limit: %d min" % GameState.offline_cap_minutes
	if GameState.offline_cap_minutes >= 120:
		offline_boost_button.text = "Offline MAX"
	else:
		offline_boost_button.text = "Offline +15m"
	_update_modal_input_state()


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


func _is_standard_input_blocked() -> bool:
	return photo_mode_active or _is_modal_open()


func _update_modal_input_state() -> void:
	if not is_node_ready():
		return
	if photo_mode_active:
		little_pot_visual.set_interaction_enabled(false)
		save_button.disabled = true
		shop_button.disabled = true
		settings_button.disabled = true
		offline_boost_button.disabled = true
		photo_button.disabled = true
		lumie.set_interaction_enabled(true)
		return

	var blocked := _is_modal_open()
	little_pot_visual.set_interaction_enabled(not blocked)
	save_button.disabled = blocked
	shop_button.disabled = blocked
	settings_button.disabled = blocked
	offline_boost_button.disabled = blocked or GameState.offline_cap_minutes >= 120
	photo_button.disabled = blocked
	lumie.set_interaction_enabled(not blocked)


func _set_standard_ui_visible(value: bool) -> void:
	ui_layer.visible = value


func _on_little_pot_pressed() -> void:
	if _is_standard_input_blocked():
		return
	EconomyService.tap_little_pot()
	status_label.text = "+%d Petal" % int(GameState.tap_value)


func _on_save_pressed() -> void:
	if _is_standard_input_blocked():
		return
	if SaveService.save_progress():
		status_label.text = "Saved ✦"
	else:
		status_label.text = "Save failed"


func _on_shop_pressed() -> void:
	if _is_standard_input_blocked():
		return
	settings_panel.visible = false
	shop_panel.open_panel()
	_update_modal_input_state()


func _on_settings_pressed() -> void:
	if _is_standard_input_blocked():
		return
	shop_panel.visible = false
	settings_panel.open_panel()
	_update_modal_input_state()


func _on_offline_boost_pressed() -> void:
	if _is_standard_input_blocked():
		return
	if GameState.offline_cap_minutes >= 120:
		status_label.text = "Offline Limit is already 120 min"
		return
	if RewardedAdService.request_offline_cap_boost():
		status_label.text = "Rewarded ad..."
	else:
		status_label.text = "Rewarded ad unavailable"


func _on_rewarded_ad_granted(reward_id: String) -> void:
	if reward_id != RewardedAdService.OFFLINE_CAP_REWARD_ID:
		return
	status_label.text = "Offline Limit +15 min ✦"
	_refresh_ui()


func _on_rewarded_ad_unavailable(reward_id: String) -> void:
	if reward_id != RewardedAdService.OFFLINE_CAP_REWARD_ID:
		return
	if GameState.offline_cap_minutes >= 120:
		status_label.text = "Offline Limit is already 120 min"
	else:
		status_label.text = "Rewarded ad unavailable"
	_refresh_ui()


func _on_photo_pressed() -> void:
	if _is_standard_input_blocked():
		return
	photo_mode_active = true
	_photo_result_message = ""
	shop_panel.visible = false
	settings_panel.visible = false
	offline_popup.visible = false
	_set_standard_ui_visible(false)
	photo_mode_ui.open_mode()
	_update_modal_input_state()


func _on_photo_exit_requested() -> void:
	if not photo_mode_active:
		return
	photo_mode_ui.close_mode()
	photo_mode_active = false
	_set_standard_ui_visible(true)
	_update_modal_input_state()
	if not _photo_result_message.is_empty():
		status_label.text = _photo_result_message


func _on_photo_capture_saved(path: String) -> void:
	_photo_result_message = "Photo saved: %s" % path


func _on_photo_capture_failed() -> void:
	_photo_result_message = "Photo capture failed"


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
	if photo_mode_active or story_overlay.is_sequence_active() or shop_panel.visible or settings_panel.visible:
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
