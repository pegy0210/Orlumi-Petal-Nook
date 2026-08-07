extends Node

signal pending_reward_ready(seconds: int, reward: float)
signal pending_reward_claimed(reward: float)

var pending_seconds: int = 0
var pending_reward: float = 0.0


func prepare_pending_reward() -> void:
	pending_seconds = 0
	pending_reward = 0.0
	if GameState.last_save_unix <= 0:
		return

	var now_unix := int(Time.get_unix_time_from_system())
	var elapsed := maxi(0, now_unix - GameState.last_save_unix)
	var cap_seconds := GameState.offline_cap_minutes * 60
	pending_seconds = mini(elapsed, cap_seconds)
	pending_reward = GameState.final_income_per_sec * float(pending_seconds) * 0.1

	if pending_reward > 0.0:
		pending_reward_ready.emit(pending_seconds, pending_reward)


func claim_pending_reward() -> float:
	if pending_reward <= 0.0:
		return 0.0
	var amount := pending_reward
	GameState.petals += amount
	pending_seconds = 0
	pending_reward = 0.0
	SaveService.save_progress()
	GameState.state_changed.emit()
	pending_reward_claimed.emit(amount)
	return amount


func increase_cap_after_rewarded_ad() -> bool:
	if GameState.offline_cap_minutes >= 120:
		return false
	GameState.offline_cap_minutes = mini(120, GameState.offline_cap_minutes + 15)
	SaveService.save_progress()
	GameState.state_changed.emit()
	return true
