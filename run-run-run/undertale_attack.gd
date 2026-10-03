extends StaticBody2D
# Small, slow Undertale-style bullet. Hit is detected by overlapping
# the battle soul's Area2D (works with the gravity-free battle_soul).
var direction := Vector2.LEFT
var speed: float = 100.0
var kind: String = "bone" # "bone" | "blaster" | "spear"
var _hit_done := false
# Blaster pellets loop around the arena once (two passes) instead of
# despawning; walls leave after one pass.
var _loops_left := -1

# Battle box bounds (must match minigame_3.gd / battle_soul.gd).
# Loops start at these edges, not the screen edges.
const BOX_MIN := Vector2(392, 176)
const BOX_MAX := Vector2(760, 432)
const EXIT_MARGIN := 24.0

var _entered_box := false

func _ready() -> void:
	add_to_group("undertale_attack")
	$BlasterSprite.visible = (kind == "blaster")
	$BoneSprite.visible = (kind != "blaster")
	# wall.png spikes at rest face +X away from travel; rotating the
	# sprite by direction.angle() brings the spikes around to lead
	# along travel. Blaster head (+X at rest) uses direction.angle().
	if kind == "blaster":
		$BlasterSprite.rotation = direction.angle()
	else:
		$BoneSprite.rotation = direction.angle()
	if kind == "blaster":
		_loops_left = 1
	else:
		_loops_left = 0
	# Slim the hitbox to the visible sprite: tall long wall for
	# bones, large blaster head as big as bulletbill (~90px).
	var col: CollisionShape2D = $CollisionShape2D
	var area_col: CollisionShape2D = $Area2D/Area2DCol
	# Each instance gets its own shape copy so kinds don't resize each other.
	col.shape = col.shape.duplicate()
	area_col.shape = area_col.shape.duplicate()
	if kind == "blaster":
		col.shape.size = Vector2(40, 18)
		area_col.shape.size = Vector2(40, 18)
	elif kind == "spear":
		col.shape.size = Vector2(90, 12)
		area_col.shape.size = Vector2(90, 12)
	else:
		col.shape.size = Vector2(12, 90)
		area_col.shape.size = Vector2(12, 90)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	_check_hit()
	_wrap_or_free()

func _wrap_or_free() -> void:
	# Spawns start outside the box, so only wrap/free after the first
	# time the bullet gets inside.
	if not _entered_box:
		if position.x > BOX_MIN.x and position.x < BOX_MAX.x \
				and position.y > BOX_MIN.y and position.y < BOX_MAX.y:
			_entered_box = true
		return
	var out := position.x < BOX_MIN.x - EXIT_MARGIN or position.x > BOX_MAX.x + EXIT_MARGIN \
		or position.y < BOX_MIN.y - EXIT_MARGIN or position.y > BOX_MAX.y + EXIT_MARGIN
	if not out:
		return
	if _loops_left > 0:
		_loops_left -= 1
		# Re-enter from the opposite box edge at the same lane,
		# keeping travel direction so the nose still leads.
		if position.x < BOX_MIN.x:
			position.x = BOX_MAX.x
		elif position.x > BOX_MAX.x:
			position.x = BOX_MIN.x
		if position.y < BOX_MIN.y:
			position.y = BOX_MAX.y
		elif position.y > BOX_MAX.y:
			position.y = BOX_MIN.y
	else:
		queue_free()

func _check_hit() -> void:
	if _hit_done:
		return
	var soul_area := get_tree().get_first_node_in_group("battle_soul_area") as Area2D
	if soul_area == null:
		return
	if soul_area.overlaps_area($Area2D):
		_hit_done = true
		var arena := get_parent()
		if arena.has_method("hit"):
			arena.hit()
