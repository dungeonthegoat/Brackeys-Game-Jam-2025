extends AnimationTree


@export var body: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var move: MovementController


func _process(_delta: float) -> void:
	if move.shrunk:
		sprite.animation = "small"
	else:
		sprite.animation = "big"
	
	if body.velocity.x == 0 and body.velocity.y == 0: return

	var blend_pos: Vector2 = body.velocity.normalized()
	set("parameters/Fly/blend_position", blend_pos)

	
