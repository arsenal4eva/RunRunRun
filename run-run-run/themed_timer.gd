extends Node2D

@onready var timer: RichTextLabel = $Timer2

var time : float

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	timer.text = str(snapped(time, 0.1))

func run_timer(start_time: float): 
	time = start_time
	
	while time > 0.0 and is_instance_valid(self) and is_inside_tree(): 
		await wait(0.1)
		time = time - 0.1
	
	time = 0.0 

func wait(seconds: float): 
	if not is_instance_valid(self) or not is_inside_tree(): 
		return
	await get_tree().create_timer(seconds).timeout 
