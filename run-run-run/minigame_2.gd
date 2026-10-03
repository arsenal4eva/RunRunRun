extends Node2D
@onready var themed_timer: Node2D = $ThemedTimer

var souls_pressed := 0
var timer_end = false

func _ready() -> void:
	await themed_timer.run_timer(7.0)
	if is_instance_valid(self) and is_inside_tree():
		timer_end = true 


func _process(delta: float) -> void:
	if souls_pressed == Global.dif2:
		Global.minigames_done += 1
		get_tree().change_scene_to_file("res://timer_screen.tscn")
	
	if timer_end:
		Global.lives -= 1
		get_tree().change_scene_to_file("res://timer_screen.tscn")
