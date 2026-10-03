extends Node2D

@onready var sans = $sans
@onready var caught = $caught
@onready var mad = $mad

func _ready() -> void:
	caught.visible = false
	mad.visible = false
	sans.visible = false
	await get_tree().create_timer(2.0).timeout
	caught.visible = true
	await get_tree().create_timer(2.0).timeout
	sans.visible = true
	await get_tree().create_timer(2.0).timeout
	mad.visible = true
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://done_screen.tscn")
	
	
	
func _process(delta: float) -> void:
	pass
