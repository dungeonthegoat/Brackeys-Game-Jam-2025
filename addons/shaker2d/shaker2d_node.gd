@tool
@icon("res://addons/shaker2d/Shaker2D.svg")
class_name Shaker2D
extends Node2D


@export_group("Config")
@export var disabled: bool = false

## How quickly to move through the noise.
@export var speed: float = 30.0

## By how much the shaker multiplies the noise value.
@export var strength: float = 60.0

## Multiplier for lerping the shake strength to zero.
@export var decay: float = 5.0

@export_tool_button("Preview Shake")
var _shake_tool_button = shake.bind()


@onready var rand = RandomNumberGenerator.new()
@onready var noise = FastNoiseLite.new()


# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var _noise_i: float = 0.0
var _shake_strength: float = 0.0
var _position: Vector2
var _offset := Vector2.ZERO

func _ready() -> void:
	rand.randomize()
	# Randomize the generated noise
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.frequency = 2.0


func _process(delta: float) -> void:
	# Fade out the intensity over time
	_shake_strength = lerp(_shake_strength, 0.0, 1 - exp(-decay * delta))
	if disabled:
		return
	_position = global_position - _offset
	_offset = _get_noise_offset(delta)
	global_position = _position + _offset


func _get_noise_offset(delta: float) -> Vector2:
	_noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, _noise_i) * _shake_strength,
		noise.get_noise_2d(100, _noise_i) * _shake_strength
	)


func shake():
	_shake_strength = strength


func apply_noise_shake(shake_speed: float, shake_strength: float, shake_decay: float) -> void:
	speed = shake_speed
	strength = shake_strength
	decay = shake_decay
	
	_shake_strength = strength
