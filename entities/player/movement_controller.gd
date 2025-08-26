class_name MovementController
extends Node


@export var body: CharacterBody2D
@export var acceleration: float = 1200.0
@export var max_speed: float = 300.0
@export var slow_speed: float = 80.0


var movement_vector: Vector2
var shrunk: bool = false


@onready var speed: float = max_speed


func _process(delta: float) -> void:
	movement_vector = Input.get_vector("left", "right", "up", "down") * speed
	body.velocity = body.velocity.move_toward(movement_vector, delta * acceleration)
	body.move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slow"):
		_toggle_shrink(true)
	elif event.is_action_released("slow"):
		_toggle_shrink(false)


func _toggle_shrink(value: bool) -> void:
	shrunk = value

	if not value:
		speed = max_speed
		return
	
	speed = slow_speed