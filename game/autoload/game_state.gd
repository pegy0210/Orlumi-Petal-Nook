extends Node

signal state_changed

const SAVE_VERSION: int = 1

var petals: float = 0.0
var little_pot_level: int = 1
var wooden_rack_level: int = 0
var curtain_level: int = 0
var small_table_level: int = 0
var comfort: int = 2
var base_income_per_sec: float = 1.0
var bonus_percent: float = 0.0
var final_income_per_sec: float = 1.0
var tap_value: float = 1.0
var area2_unlocked: bool = false
var intro_played: bool = false
var lumie_unlocked: bool = false
var lumie_intro_played: bool = false
var offline_cap_minutes: int = 60
var last_save_unix: int = 0
var save_version: int = SAVE_VERSION


func reset_to_defaults() -> void:
	petals = 0.0
	little_pot_level = 1
	wooden_rack_level = 0
	curtain_level = 0
	small_table_level = 0
	comfort = 2
	base_income_per_sec = 1.0
	bonus_percent = 0.0
	final_income_per_sec = 1.0
	tap_value = 1.0
	area2_unlocked = false
	intro_played = false
	lumie_unlocked = false
	lumie_intro_played = false
	offline_cap_minutes = 60
	last_save_unix = 0
	save_version = SAVE_VERSION
	state_changed.emit()


func to_save_dict() -> Dictionary:
	return {
		"save_version": save_version,
		"petals": petals,
		"little_pot_level": little_pot_level,
		"wooden_rack_level": wooden_rack_level,
		"curtain_level": curtain_level,
		"small_table_level": small_table_level,
		"area2_unlocked": area2_unlocked,
		"intro_played": intro_played,
		"lumie_unlocked": lumie_unlocked,
		"lumie_intro_played": lumie_intro_played,
		"offline_cap_minutes": offline_cap_minutes,
		"last_save_unix": last_save_unix
	}


func apply_save_dict(data: Dictionary) -> void:
	save_version = int(data.get("save_version", SAVE_VERSION))
	petals = maxf(0.0, float(data.get("petals", 0.0)))
	little_pot_level = clampi(int(data.get("little_pot_level", 1)), 1, 5)
	wooden_rack_level = clampi(int(data.get("wooden_rack_level", 0)), 0, 5)
	curtain_level = clampi(int(data.get("curtain_level", 0)), 0, 5)
	small_table_level = clampi(int(data.get("small_table_level", 0)), 0, 5)
	area2_unlocked = bool(data.get("area2_unlocked", false))
	intro_played = bool(data.get("intro_played", false))
	lumie_unlocked = bool(data.get("lumie_unlocked", false))
	lumie_intro_played = bool(data.get("lumie_intro_played", false))
	offline_cap_minutes = clampi(int(data.get("offline_cap_minutes", 60)), 60, 120)
	last_save_unix = maxi(0, int(data.get("last_save_unix", 0)))
	state_changed.emit()
