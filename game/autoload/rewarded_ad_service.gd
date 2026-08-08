extends Node

signal reward_granted(reward_id: String)
signal reward_unavailable(reward_id: String)

const OFFLINE_CAP_REWARD_ID := "offline_cap_plus_15"

var provider_available: bool = false


func set_provider_available(available: bool) -> void:
	provider_available = available


func request_offline_cap_boost() -> bool:
	if GameState.offline_cap_minutes >= 120:
		return false
	return request_reward(OFFLINE_CAP_REWARD_ID)


func request_reward(reward_id: String) -> bool:
	# Developer builds may simulate a completed rewarded ad so the game flow can
	# be validated before an Android ad provider is selected and integrated.
	if OS.is_debug_build() and not provider_available:
		call_deferred("notify_rewarded_ad_completed", reward_id)
		return true

	if not provider_available:
		reward_unavailable.emit(reward_id)
		return false

	# The future Android provider adapter starts the rewarded ad here.
	# Reward is granted only after that adapter calls notify_rewarded_ad_completed().
	return true


func notify_rewarded_ad_completed(reward_id: String) -> void:
	match reward_id:
		OFFLINE_CAP_REWARD_ID:
			if OfflineService.increase_cap_after_rewarded_ad():
				reward_granted.emit(reward_id)
			else:
				reward_unavailable.emit(reward_id)
		_:
			reward_unavailable.emit(reward_id)
