extends RefCounted

# Orlumi: Petal Nook — MainRoom layout source of truth.
#
# These values are provisional calibration coordinates until the approved
# BgRoom is integrated. Once BgRoom is approved, tune this file rather than
# scattering coordinate edits across scenes and gameplay scripts.

const REFERENCE_VIEWPORT := Vector2(1080.0, 1920.0)

# Background composition / review zones.
const HUD_SAFE_ZONE := Rect2(32.0, 32.0, 520.0, 360.0)
const RIGHT_CONTROLS_SAFE_ZONE := Rect2(740.0, 32.0, 308.0, 470.0)
const ACTIVE_GAMEPLAY_FLOOR := Rect2(90.0, 650.0, 700.0, 900.0)
const AREA2_RESERVE := Rect2(780.0, 560.0, 300.0, 1010.0)

# Furniture rectangles are expressed in 1080x1920 reference coordinates.
# The rectangle size matches the approved source-asset contract where useful,
# so art can be swapped without changing gameplay code.
const FURNITURE_RECTS := {
	"curtain": Rect2(105.0, 565.0, 360.0, 260.0),
	"wooden_rack": Rect2(560.0, 790.0, 320.0, 420.0),
	"little_pot": Rect2(385.0, 1135.0, 280.0, 280.0),
	"small_table": Rect2(700.0, 1190.0, 300.0, 300.0),
}

# Companion movement deliberately remains left of the reserved Area 2 region.
const LUMIE_START_POSITION := Vector2(220.0, 980.0)
const LUMIE_MOVEMENT_BOUNDS := Rect2(140.0, 760.0, 560.0, 480.0)


static func get_furniture_rect(item_id: String) -> Rect2:
	return FURNITURE_RECTS.get(item_id, Rect2()) as Rect2


static func get_furniture_anchor(item_id: String) -> Vector2:
	var rect := get_furniture_rect(item_id)
	return rect.position + rect.size * 0.5


static func is_rect_inside_reference(rect: Rect2) -> bool:
	return (
		rect.position.x >= 0.0
		and rect.position.y >= 0.0
		and rect.end.x <= REFERENCE_VIEWPORT.x
		and rect.end.y <= REFERENCE_VIEWPORT.y
	)
