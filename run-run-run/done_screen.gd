extends Node2D


func _on_replay_pressed() -> void:
	Global.win = false
	Global.minigames_done = 0
	Global.lives = 5
	get_tree().change_scene_to_file("res://title_screen.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
