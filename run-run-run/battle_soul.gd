extends CharacterBody2D
# Level 3 battle soul: gravity-free Undertale-style movement.
# WASD and arrow keys both work (ui_left/right/up/down); the soul
# glides on the x/y plane and is clamped inside the battle box.
const SPEED := 220.0

# Battle box bounds (must match the BattleBox visuals in minigame_3.tscn).
var box_min := Vector2(392, 176)
var box_max := Vector2(760, 432)

func _ready() -> void:
	$Area2D.add_to_group("battle_soul_area")

func _physics_process(_delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	if direction.length() > 1.0:
		direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
	position = position.clamp(box_min, box_max)
