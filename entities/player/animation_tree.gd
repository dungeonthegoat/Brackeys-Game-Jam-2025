extends AnimationTree


@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var move: MovementController
@export var collision: Hitbox2D


func _ready() -> void:
	collision.hurt.connect(_hurt)


func _process(_delta: float) -> void:
	if move.shrunk:
		sprite.animation = "small"
	else:
		sprite.animation = "big"
	
	if body.velocity.x == 0 and body.velocity.y == 0: return

	var blend_pos: Vector2 = body.velocity.normalized()
	set("parameters/Fly/blend_position", blend_pos)
	set("parameters/Hurt/blend_position", blend_pos)


func _hurt(_amount: int) -> void:
	set("parameters/conditions/hurt", true)
	await get_tree().create_timer(0.1).timeout
	set("parameters/conditions/hurt", false)
