@tool
class_name CircularOscillator2D
extends Oscillator2D


@export var initial_rotation: float
@export var rotation_speed: float = 1.0
@export var radius: float = 32.0
@export var playing: bool = false
@export var autoplay: bool = false


func _ready() -> void:
	if not Engine.is_editor_hint() and autoplay:
		playing = true

var angle: float = 0
var t: float = 0


func _process(delta: float) -> void:
	if not playing:
		t = 0
	else:
		t += delta
	
	angle = wrapf(initial_rotation + t * rotation_speed, 0, TAU)
	position = radius * Vector2(cos(angle), sin(angle))