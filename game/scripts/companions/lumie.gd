extends Control

signal reaction_started(emoji: String)
signal annoyed_started
signal annoyed_ended
signal companion_state_changed(state_name: String)

enum State {
	LOCKED,
	IDLE,
	MOVING,
	REACTING,
	COOLDOWN,
	ANNOYED
}

const NORMAL_EMOJIS: Array[String] = ["🌸", "✨", "😊", "💛", "😴", "❔"]
const EMOJI_VISIBLE_SECONDS := 2.0
const ANNOYED_SECONDS := 30.0
const MAX_TARGET_ATTEMPTS := 18

@export var movement_bounds := Rect2(105.0, 720.0, 700.0, 700.0)
@export var min_move_wait_seconds := 2.5
@export var max_move_wait_seconds := 5.0
@export var min_move_duration_seconds := 1.6
@export var max_move_duration_seconds := 3.0
@export var min_cooldown_seconds := 1.0
@export var max_cooldown_seconds := 2.0

@onready var shadow_texture: TextureRect = $ShadowTexture
@onready var body_texture: TextureRect = $BodyTexture
@onready var fallback_label: Label = $FallbackLabel
@onready var body_button: Button = $BodyButton
@onready var emoji_label: Label = $Emoji
@onready var move_timer: Timer = $MoveTimer
@onready var emoji_timer: Timer = $EmojiTimer
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var annoyed_timer: Timer = $AnnoyedTimer

var current_state: State = State.LOCKED
var successful_tap_count: int = 0
var interaction_enabled: bool = true
var movement_exclusion_rects: Array[Rect2] = []
var _rng := RandomNumberGenerator.new()
var _move_tween: Tween


func _ready() -> void:
	_rng.randomize()
	body_button.pressed.connect(_on_body_pressed)
	move_timer.timeout.connect(_on_move_timer_timeout)
	emoji_timer.timeout.connect(_on_emoji_timer_timeout)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	annoyed_timer.timeout.connect(_on_annoyed_timer_timeout)
	GameState.state_changed.connect(_refresh_unlock_state)
	emoji_label.visible = false
	_refresh_unlock_state()
	_apply_interaction_state()


func set_interaction_enabled(enabled: bool) -> void:
	interaction_enabled = enabled
	_apply_interaction_state()


func set_movement_exclusions(rects: Array[Rect2]) -> void:
	movement_exclusion_rects = rects.duplicate()


func _apply_interaction_state() -> void:
	if not is_node_ready():
		return
	body_button.disabled = not interaction_enabled


func _refresh_unlock_state() -> void:
	if not GameState.lumie_unlocked:
		visible = false
		_stop_all_activity()
		successful_tap_count = 0
		_set_state(State.LOCKED)
		return

	visible = true
	if current_state == State.LOCKED:
		_apply_visual_state("normal")
		_set_state(State.IDLE)
		_schedule_next_move()


func _apply_visual_state(state_name: String) -> void:
	if not is_node_ready():
		return
	var texture := VisualAssetService.get_companion_texture("lumie", state_name)
	body_texture.texture = texture
	body_texture.visible = texture != null
	fallback_label.visible = texture == null
	fallback_label.text = "Lumie\n(annoyed)" if state_name == "annoyed" else "Lumie ✦"

	var shadow := VisualAssetService.get_companion_shadow("lumie")
	shadow_texture.texture = shadow
	shadow_texture.visible = shadow != null


func _on_body_pressed() -> void:
	if not interaction_enabled or not GameState.lumie_unlocked:
		return
	if current_state in [State.REACTING, State.COOLDOWN, State.ANNOYED, State.LOCKED]:
		return

	_stop_move_tween()
	successful_tap_count += 1

	if _should_become_annoyed(successful_tap_count):
		_enter_annoyed()
		return

	_start_normal_reaction()


func _start_normal_reaction() -> void:
	move_timer.stop()
	_set_state(State.REACTING)
	var emoji := NORMAL_EMOJIS[_rng.randi_range(0, NORMAL_EMOJIS.size() - 1)]
	emoji_label.text = emoji
	emoji_label.visible = true
	emoji_timer.start(EMOJI_VISIBLE_SECONDS)
	reaction_started.emit(emoji)


func _on_emoji_timer_timeout() -> void:
	emoji_label.visible = false
	if current_state != State.REACTING:
		return
	_set_state(State.COOLDOWN)
	cooldown_timer.start(_rng.randf_range(min_cooldown_seconds, max_cooldown_seconds))


func _on_cooldown_timer_timeout() -> void:
	if current_state != State.COOLDOWN:
		return
	_set_state(State.IDLE)
	_schedule_next_move()


func _should_become_annoyed(tap_count: int) -> bool:
	if tap_count < 6:
		return false
	var chance := 0.25
	if tap_count >= 10:
		chance = 1.0
	elif tap_count >= 8:
		chance = 0.50
	return _rng.randf() < chance


func _enter_annoyed() -> void:
	move_timer.stop()
	emoji_timer.stop()
	cooldown_timer.stop()
	_stop_move_tween()
	_set_state(State.ANNOYED)
	_apply_visual_state("annoyed")
	if _rng.randf() < 0.5:
		emoji_label.text = "😠"
		emoji_label.visible = true
	else:
		emoji_label.visible = false
	annoyed_timer.start(ANNOYED_SECONDS)
	annoyed_started.emit()


func _on_annoyed_timer_timeout() -> void:
	if current_state != State.ANNOYED:
		return
	successful_tap_count = 0
	emoji_label.visible = false
	_apply_visual_state("normal")
	_set_state(State.IDLE)
	annoyed_ended.emit()
	_schedule_next_move()


func _schedule_next_move() -> void:
	if current_state != State.IDLE or not GameState.lumie_unlocked:
		return
	move_timer.start(_rng.randf_range(min_move_wait_seconds, max_move_wait_seconds))


func _on_move_timer_timeout() -> void:
	if current_state != State.IDLE or not GameState.lumie_unlocked:
		return
	_start_move_to_random_point()


func _start_move_to_random_point() -> void:
	var target := _pick_valid_movement_target()
	var duration := _rng.randf_range(min_move_duration_seconds, max_move_duration_seconds)
	_set_state(State.MOVING)
	_move_tween = create_tween()
	_move_tween.set_trans(Tween.TRANS_SINE)
	_move_tween.set_ease(Tween.EASE_IN_OUT)
	_move_tween.tween_property(self, "position", target, duration)
	_move_tween.finished.connect(_on_move_finished)


func _pick_valid_movement_target() -> Vector2:
	for _attempt in range(MAX_TARGET_ATTEMPTS):
		var candidate := Vector2(
			_rng.randf_range(movement_bounds.position.x, movement_bounds.end.x),
			_rng.randf_range(movement_bounds.position.y, movement_bounds.end.y)
		)
		if _is_valid_movement_point(candidate):
			return candidate
	return movement_bounds.get_center()


func _is_valid_movement_point(point: Vector2) -> bool:
	for rect in movement_exclusion_rects:
		if rect.has_point(point):
			return false
	return true


func _on_move_finished() -> void:
	_move_tween = null
	if current_state != State.MOVING:
		return
	_set_state(State.IDLE)
	_schedule_next_move()


func _stop_move_tween() -> void:
	if _move_tween != null and _move_tween.is_valid():
		_move_tween.kill()
	_move_tween = null
	if current_state == State.MOVING:
		_set_state(State.IDLE)


func _stop_all_activity() -> void:
	move_timer.stop()
	emoji_timer.stop()
	cooldown_timer.stop()
	annoyed_timer.stop()
	_stop_move_tween()
	emoji_label.visible = false


func _set_state(next_state: State) -> void:
	if current_state == next_state:
		return
	current_state = next_state
	companion_state_changed.emit(_state_name(next_state))


func _state_name(state: State) -> String:
	match state:
		State.LOCKED: return "locked"
		State.IDLE: return "idle"
		State.MOVING: return "moving"
		State.REACTING: return "reacting"
		State.COOLDOWN: return "cooldown"
		State.ANNOYED: return "annoyed"
	return "unknown"
