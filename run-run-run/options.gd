extends Node2D

@onready var lose = $Lose
@onready var win = $Win


func _ready() -> void:
	lose.visible = not Global.win
	win.visible = Global.win
	
	
	
func _process(delta: float) -> void:
	pass


func _on_replay_pressed() -> void:
	Global.win = false
	Global.minigames_done = 0
	Global.lives = 5
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_end_pressed() -> void:
	if Global.win:
		get_tree().change_scene_to_file("res://win.tscn")
	else:
		get_tree().change_scene_to_file("res://lose.tscn")
