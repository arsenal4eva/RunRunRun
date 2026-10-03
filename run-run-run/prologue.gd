extends Node2D

const NEXT_SCENE := "res://timer_screen.tscn"
const LINE_PAUSE := 1
const HOLD_AFTER_ALL := 4.0

var _advanced := false

func _ready() -> void:
	_reveal_sequence()

func _reveal_sequence() -> void:
	var container: VBoxContainer = $VBoxContainer
	var labels: Array[Node] = container.get_children()
	for label in labels:
		label.visible = false
	for label in labels:
		if _advanced or not is_instance_valid(self) or not is_inside_tree():
			return
		await get_tree().create_timer(LINE_PAUSE).timeout
		if _advanced or not is_instance_valid(label):
			return
		label.visible = true
	await get_tree().create_timer(HOLD_AFTER_ALL).timeout
	_advance()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		_advance()
	elif event is InputEventMouseButton and event.pressed:
		_advance()

func _advance() -> void:
	if _advanced:
		return
	_advanced = true
	get_tree().change_scene_to_file(NEXT_SCENE)
