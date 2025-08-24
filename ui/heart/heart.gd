@tool
class_name HeartIcon
extends Control


enum State {
	FULL,
	HALF,
	EMPTY
}


const HEART_FULL: Texture2D = preload("res://ui/heart/heart_full.png")
const HEART_HALF: Texture2D = preload("res://ui/heart/heart_half.png")
const HEART_EMPTY: Texture2D = preload("res://ui/heart/heart_empty.png")


var jiggle_amplitude: float = 0.0
var jiggle_t: float = 0.0
var jiggle_dt: float = 0.0
var jiggle_vector: Vector2
var jiggle_decay: float = 7.0
var jiggle_freq: float = 3.0


@export var texture: TextureRect
@export var state: State = State.FULL:
	set(new_state):
		if state == new_state: return
		state = new_state
		_update_state(new_state)


func _process(delta: float) -> void:
	if jiggle_amplitude <= 0.001 or not texture:
		if texture:
			texture.scale = Vector2.ONE
		return
	
	jiggle_t += delta
	jiggle_dt = sin(TAU * jiggle_freq * jiggle_t) * jiggle_amplitude
	jiggle_amplitude = lerpf(jiggle_amplitude, 0, 1 - exp(-jiggle_decay * delta))
	jiggle_vector.y = 1.0 + jiggle_dt
	jiggle_vector.x = 1.0 / jiggle_vector.y
	texture.scale = jiggle_vector


func _update_state(new_state: State) -> void:
	jiggle_freq = randf_range(4.0, 6.0)
	jiggle_amplitude = randf_range(0.18, 0.25)
	
	match new_state:
		State.FULL:
			texture.texture = HEART_FULL
		State.HALF:
			texture.texture = HEART_HALF
		State.EMPTY:
			texture.texture = HEART_EMPTY
