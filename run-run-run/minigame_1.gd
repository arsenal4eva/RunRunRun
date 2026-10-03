extends Node2D
@onready var themed_timer: Node2D = $ThemedTimer 

var soul_collected = 0 
var timer_end = false 

func _ready() -> void:

	for soul in [$SoulFragment, $SoulFragment2, $SoulFragment3, $SoulFragment4, $SoulFragment5]:
		soul.soul_collected.connect(collect_soul)

	await themed_timer.run_timer(15.0) 
	if is_instance_valid(self) and is_inside_tree():
		timer_end = true 
func _process(delta: float) -> void: 
	if soul_collected == Global.dif1: 
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://timer_screen.tscn") 
	if timer_end:  
		Global.lives -= 1 
		get_tree().change_scene_to_file("res://timer_screen.tscn") 
		

func collect_soul() -> void: 
	soul_collected = soul_collected +1
	return
