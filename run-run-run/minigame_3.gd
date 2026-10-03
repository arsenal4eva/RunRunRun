extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var soul: CharacterBody2D = $Soul
@onready var glitch = $Glitch

var attack_scene = preload("res://undertale_attack.tscn")

var timer_end := false
var is_hit := false
var attack_index := 0
var elapsed := 0.0

const SURVIVE_TIME := 45.0

const BOX_MIN := Vector2(392, 176)
const BOX_MAX := Vector2(760, 432)

const MAX_ALIVE := 10

func _ready() -> void:
	glitch.visible = false
	_style_timer()
	spawn_next_attack()
	await themed_timer.run_timer(SURVIVE_TIME)
	if is_instance_valid(self) and is_inside_tree() and not is_hit:
		timer_end = true

# battle.png is white, so the shared white timer text is invisible.
# Style minigame 3's label in code: black, centered on the battlebox.
func _style_timer() -> void:
	var label := themed_timer.get_node("Timer2") as RichTextLabel
	label.position = Vector2(-70, -25)
	label.size = Vector2(140, 50)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("default_color", Color.BLACK)
	label.add_theme_font_size_override("normal_font_size", 30)

func _process(delta: float) -> void:
	elapsed += delta
	if timer_end:
		Global.win = true
		glitch.visible = true
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://options.tscn")

func hit() -> void:
	if is_hit:
		return
	is_hit = true
	Global.lives -= 1
	if Global.lives <= 0:
		get_tree().change_scene_to_file("res://options.tscn")
	else:
		get_tree().change_scene_to_file("res://timer_screen.tscn")


func _difficulty() -> float:
	return clampf(elapsed / SURVIVE_TIME, 0.0, 1.0)

func _ramped_speed(base: float) -> float:
	return base * (1.0 + Global.dif31 * _difficulty())

func _ramped_rest(base: float) -> float:
	return base * (1.0 - Global.dif32 * _difficulty())

func _alive_count() -> int:
	var n := 0
	for c in get_children():
		if c.is_in_group("undertale_attack"):
			n += 1
	return n

func spawn_next_attack() -> void:
	if is_hit or timer_end or not is_inside_tree():
		return
	if _alive_count() >= MAX_ALIVE:
		await get_tree().create_timer(0.8).timeout
		if is_hit or timer_end or not is_inside_tree():
			return
		if _alive_count() >= MAX_ALIVE:
			spawn_next_attack()
			return
	match attack_index % 4:
		0:
			_side_bones_pattern()
		1:
			_top_spears_pattern()
		2:
			_blaster_pattern()
		3:
			_cross_pattern()
	attack_index += 1

func _spawn_attack(kind: String, pos: Vector2, dir: Vector2, attack_speed: float) -> void:
	if _alive_count() >= MAX_ALIVE:
		return
	var attack = attack_scene.instantiate()
	attack.kind = kind
	attack.position = pos
	attack.direction = dir
	attack.speed = attack_speed
	add_child(attack)

func _side_bones_pattern() -> void:
	
	var y := clampf(soul.global_position.y + randf_range(-60.0, 60.0), BOX_MIN.y + 20.0, BOX_MAX.y - 20.0)
	_spawn_attack("bone", Vector2(BOX_MIN.x - 96.0, y), Vector2.RIGHT, _ramped_speed(130.0))
	await get_tree().create_timer(_ramped_rest(0.9)).timeout
	if is_hit or timer_end:
		return
	_spawn_attack("bone", Vector2(BOX_MAX.x + 96.0, y + randf_range(-40.0, 40.0)), Vector2.LEFT, _ramped_speed(130.0))
	await get_tree().create_timer(_ramped_rest(2.2)).timeout
	spawn_next_attack()

func _top_spears_pattern() -> void:
	var x := randf_range(BOX_MIN.x + 60.0, BOX_MAX.x - 140.0)
	_spawn_attack("spear", Vector2(x, BOX_MIN.y - 74.0), Vector2.DOWN, _ramped_speed(140.0))
	await get_tree().create_timer(_ramped_rest(0.9)).timeout
	if is_hit or timer_end:
		return
	_spawn_attack("spear", Vector2(x + 110.0, BOX_MIN.y - 74.0), Vector2.DOWN, _ramped_speed(140.0))
	await get_tree().create_timer(_ramped_rest(2.2)).timeout
	spawn_next_attack()

func _blaster_pattern() -> void:

	var corners := [BOX_MIN, Vector2(BOX_MAX.x, BOX_MIN.y), Vector2(BOX_MIN.x, BOX_MAX.y), BOX_MAX]
	var start: Vector2 = corners[randi() % 4]
	var target := BOX_MIN + BOX_MAX - start 
	var dir: Vector2 = (target - start).normalized()

	var side := Vector2(-dir.y, dir.x)
	var count := 4 if randf() < 0.25 + 0.6 * _difficulty() else 3
	for i in range(count):
		var lane := (float(i) - float(count - 1) / 2.0) * 85.0
		var pos := start - dir * 60.0 + side * lane
		_spawn_attack("blaster", pos, dir, _ramped_speed(110.0))
		await get_tree().create_timer(_ramped_rest(0.35)).timeout
		if is_hit or timer_end:
			return
	await get_tree().create_timer(_ramped_rest(2.0)).timeout
	spawn_next_attack()

func _cross_pattern() -> void:

	var x := randf_range(BOX_MIN.x + 40.0, BOX_MAX.x - 40.0)
	_spawn_attack("spear", Vector2(x, BOX_MIN.y - 74.0), Vector2.DOWN, _ramped_speed(135.0))
	await get_tree().create_timer(_ramped_rest(0.9)).timeout
	if is_hit or timer_end:
		return
	_spawn_attack("spear", Vector2(x + randf_range(-80.0, 80.0), BOX_MAX.y + 84.0), Vector2.UP, _ramped_speed(135.0))
	await get_tree().create_timer(_ramped_rest(2.2)).timeout
	spawn_next_attack()
