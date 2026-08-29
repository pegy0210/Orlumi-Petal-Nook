extends RefCounted

# Orlumi: Petal Nook — MainRoom layout source of truth.
# MainRoom Layout A was owner-approved: central free-movement composition.
# AREA2_RESERVE is spatial capacity only. It is not visible in the base room.

const REFERENCE_VIEWPORT := Vector2(1080.0, 1920.0)

# GDevelop-derived HUD composition: four status rows left, five compact controls right.
const HUD_SAFE_ZONE := Rect2(32.0, 32.0, 500.0, 390.0)
const RIGHT_CONTROLS_SAFE_ZONE := Rect2(555.0, 32.0, 493.0, 170.0)

# Layout A keeps the largest practical central floor open for Lumie.
const ACTIVE_GAMEPLAY_FLOOR := Rect2(70.0, 620.0, 790.0, 1010.0)
const AREA2_RESERVE := Rect2(860.0, 560.0, 220.0, 1040.0)

# Runtime display rectangles. Source PNG contract sizes remain defined in assets/README.md.
# Display rectangles may scale those source PNGs to keep the room spacious.
const FURNITURE_RECTS := {
	"curtain": Rect2(88.0, 520.0, 330.0, 238.0),
	"wooden_rack": Rect2(600.0, 735.0, 250.0, 330.0),
	"little_pot": Rect2(430.0, 1160.0, 180.0, 180.0),
	"small_table": Rect2(600.0, 1290.0, 250.0, 250.0),
}

# When Small Table is owned, the Little Pot moves onto the table.
# This slot intentionally leaves enough table-top room for Lv4/Lv5 decorative details.
const LITTLE_POT_FLOOR_RECT := Rect2(430.0, 1160.0, 180.0, 180.0)
const LITTLE_POT_ON_TABLE_RECT := Rect2(645.0, 1190.0, 155.0, 155.0)

# Lumie is smaller relative to the enlarged room and may roam broadly across the main floor.
# The right-side Area 2 reserve remains excluded.
const LUMIE_START_POSITION := Vector2(300.0, 1040.0)
const LUMIE_MOVEMENT_BOUNDS := Rect2(105.0, 720.0, 700.0, 700.0)


static func get_furniture_rect(item_id: String) -> Rect2:
	return FURNITURE_RECTS.get(item_id, Rect2()) as Rect2


static func get_little_pot_rect(small_table_owned: bool) -> Rect2:
	return LITTLE_POT_ON_TABLE_RECT if small_table_owned else LITTLE_POT_FLOOR_RECT


static func get_furniture_anchor(item_id: String) -> Vector2:
	var rect := get_furniture_rect(item_id)
	return rect.position + rect.size * 0.5


static func get_lumie_exclusion_rects(
	wooden_rack_owned: bool,
	small_table_owned: bool
) -> Array[Rect2]:
	var result: Array[Rect2] = []
	if wooden_rack_owned:
		result.append(get_furniture_rect("wooden_rack").grow(28.0))
	if small_table_owned:
		result.append(get_furniture_rect("small_table").grow(35.0))
	else:
		result.append(LITTLE_POT_FLOOR_RECT.grow(20.0))
	return result


static func is_rect_inside_reference(rect: Rect2) -> bool:
	return (
		rect.position.x >= 0.0
		and rect.position.y >= 0.0
		and rect.end.x <= REFERENCE_VIEWPORT.x
		and rect.end.y <= REFERENCE_VIEWPORT.y
	)
