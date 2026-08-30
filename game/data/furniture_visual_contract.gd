extends RefCounted

# Orlumi: Petal Nook — approved furniture visual contract.
# This file keeps art dimensions and level-progression rules machine-readable
# so final PNGs can be validated without changing gameplay balance.

const ASSET_SIZES := {
	"little_pot": Vector2i(280, 280),
	"wooden_rack": Vector2i(320, 420),
	"curtain": Vector2i(360, 260),
	"small_table": Vector2i(300, 300),
}

const MAX_LEVEL := 5

const PROGRESSION := {
	"wooden_rack": {
		1: "raw branch rack + one relevant keepsake",
		2: "second relevant keepsake on the same level",
		3: "third keepsake introduced on another shelf",
		4: "fourth keepsake + restrained refinement",
		5: "same collection fully refined with premium Orlumi finishing",
	},
	"curtain": {
		1: "two-sided airy curtain",
		2: "add elegant ties",
		3: "add first small window-sill keepsake",
		4: "add second restrained keepsake/detail",
		5: "premium textile finishing while preserving the same curtain identity",
	},
	"small_table": {
		1: "bare single-leg round table; no cloth",
		2: "plain full-cover tablecloth",
		3: "plain cloth + one side keepsake",
		4: "subtle floral cloth + one side keepsake",
		5: "richer layered/shorter sheer or square top cloth + two side keepsakes",
	},
}

# Little Pot must remain placeable on Small Table Lv4/Lv5.
# The central clearance is an art-safe zone, not a collision box.
const SMALL_TABLE_POT_CLEARANCE_DIAMETER := 160
const SMALL_TABLE_POT_CLEARANCE_CENTER := Vector2i(150, 118)

const FORBIDDEN_UNRELATED_PROPS := [
	"money bag",
	"bird figurine",
	"generic bunny figurine",
	"random bottle collection",
]

static func get_asset_size(item_id: String) -> Vector2i:
	return ASSET_SIZES.get(item_id, Vector2i.ZERO) as Vector2i

static func has_complete_progression(item_id: String) -> bool:
	if not PROGRESSION.has(item_id):
		return false
	var item_progression: Dictionary = PROGRESSION[item_id]
	for level in range(1, MAX_LEVEL + 1):
		if not item_progression.has(level):
			return false
	return true
