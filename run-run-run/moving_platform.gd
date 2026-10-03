extends AnimatableBody2D

@export var axis: String = "x"
@export var distance: float = 150.0
@export var speed: float = 1.5

var _t := 0.0
var _start := Vector2.ZERO

func _ready() -> void:
	_start = position
	_t = randf() * TAU

func _physics_process(delta: float) -> void:
	_t += delta * speed
	var offset := sin(_t) * distance
	if axis == "y":
		position = _start + Vector2(0, offset)
	else:
		position = _start + Vector2(offset, 0)
