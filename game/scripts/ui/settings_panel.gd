extends Panel

signal close_requested
signal reset_completed

@onready var close_button: Button = $Content/TopBar/Close
@onready var reset_button: Button = $Content/ResetGame
@onready var first_confirm: Panel = $FirstConfirm
@onready var first_cancel: Button = $FirstConfirm/Cancel
@onready var first_continue: Button = $FirstConfirm/Continue
@onready var final_confirm: Panel = $FinalConfirm
@onready var final_cancel: Button = $FinalConfirm/Cancel
@onready var final_reset: Button = $FinalConfirm/Reset


func _ready() -> void:
	visible = false
	first_confirm.visible = false
	final_confirm.visible = false
	close_button.pressed.connect(close_panel)
	reset_button.pressed.connect(_on_reset_requested)
	first_cancel.pressed.connect(_cancel_reset)
	first_continue.pressed.connect(_show_final_confirm)
	final_cancel.pressed.connect(_cancel_reset)
	final_reset.pressed.connect(_perform_reset)


func open_panel() -> void:
	first_confirm.visible = false
	final_confirm.visible = false
	visible = true


func close_panel() -> void:
	first_confirm.visible = false
	final_confirm.visible = false
	visible = false
	close_requested.emit()


func _on_reset_requested() -> void:
	first_confirm.visible = true
	final_confirm.visible = false


func _show_final_confirm() -> void:
	first_confirm.visible = false
	final_confirm.visible = true


func _cancel_reset() -> void:
	first_confirm.visible = false
	final_confirm.visible = false


func _perform_reset() -> void:
	OfflineService.clear_pending_reward()
	SaveService.reset_progress()
	first_confirm.visible = false
	final_confirm.visible = false
	visible = false
	reset_completed.emit()
