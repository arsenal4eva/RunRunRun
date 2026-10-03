extends Node2D


func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass


func _on_beginner_pressed() -> void:
	Global.dif1 = 1
	Global.dif2 = 2
	Global.dif31 = 1
	Global.dif32 = 0
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_intermediate_pressed() -> void:
	Global.dif1 = 3
	Global.dif2 = 4
	Global.dif31 = 3
	Global.dif32 = 1
	get_tree().change_scene_to_file("res://title_screen.tscn")
	
func _on_advanced_pressed() -> void:
	Global.dif1 = 4
	Global.dif2 = 5
	Global.dif31 = 6
	Global.dif32 = 2
	get_tree().change_scene_to_file("res://title_screen.tscn")
	
func _on_impossible_pressed() -> void:
	Global.dif1 = 5
	Global.dif2 = 7
	Global.dif31 = 10
	Global.dif32 = 4 
	get_tree().change_scene_to_file("res://title_screen.tscn")
