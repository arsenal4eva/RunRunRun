extends Node2D
@onready var soul_container: HBoxContainer = $SoulContainer
@onready var soul: TextureRect = $SoulContainer/Soul
@onready var soul_2: TextureRect = $SoulContainer/Soul2
@onready var soul_3: TextureRect = $SoulContainer/Soul3
@onready var soul_4: TextureRect = $SoulContainer/Soul4
@onready var soul_5: TextureRect = $SoulContainer/Soul5
@onready var level: RichTextLabel = $Level
@onready var timer: RichTextLabel = $Timer
const SOUL_FULL: Texture2D = preload("res://soul_heart.png")
const SOUL_BROKEN: Texture2D = preload("res://broken_soul.png")

var time

func _ready() -> void:
	if Global.lives == 0:
		get_tree().change_scene_to_file("res://lose.tscn")
	await run_timer(5.0) 
	
	if Global.minigames_done < 3: 
		get_tree().change_scene_to_file("res://minigame_" + str(Global.minigames_done + 1) + ".tscn")

	else:
		if Global.lives == 0:
			get_tree().change_scene_to_file("res://lose.tscn")
		else:
			get_tree().change_scene_to_file("done_screen.tscn") 
	

func _process(delta: float) -> void:
	_update_souls()
	timer.text = str(time)
	level.text = "Level " + str(Global.minigames_done+1)

func _update_souls() -> void:
	var souls: Array = [soul, soul_2, soul_3, soul_4, soul_5]
	for i in souls.size():
		var rect: TextureRect = souls[i]
		if not is_instance_valid(rect):
			continue
		rect.visible = true
		rect.texture = SOUL_FULL if Global.lives > i else SOUL_BROKEN

func run_timer(start_time: float): 
	time = start_time
	
	while time > 0.0 and is_instance_valid(self) and is_inside_tree(): 
		await wait(0.1)
		time -= 0.1 
	
	return

func wait(seconds: float) -> void: 
	if not is_instance_valid(self) or not is_inside_tree():
		return
	await get_tree().create_timer(seconds).timeout
