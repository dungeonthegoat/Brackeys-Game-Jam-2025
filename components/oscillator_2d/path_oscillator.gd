@tool
class_name PathOscillator2D
extends PathFollow2D


@export var follow_speed: float = 10.0
@export var playing: bool = false
@export var autoplay: bool = false
@export var ping_pong: bool = false:
	set(ping):
		ping_pong = ping
		loop = not ping_pong


var dir: float = 1.0


func _ready() -> void:
	progress = 0
	if autoplay:
		playing = true


func _process(delta: float) -> void:
	if playing:
		progress += follow_speed * delta * dir
	else:
		progress = 0
	
	if progress_ratio == 1.0 and ping_pong:
		dir = -1.0
	elif progress_ratio == 0.0 and ping_pong:
		dir = 1.0