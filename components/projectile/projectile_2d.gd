@tool
@icon("res://components/projectile/projectile_2d.svg")
class_name Projectile2D
extends Sprite2D


const ARENA_WIDTH: int = 576
const ARENA_HEIGHT: int = 324


@export var projectile: Projectile:
	set(new_proj):
		projectile = new_proj
		if new_proj == null: return
		_update_projectile(new_proj)


var movement: ProjectileMovementPattern

var velocity: Vector2
var global_velocity: Vector2 = Vector2.ZERO
var noise_velocity: Vector2
var rot_speed: float

var life_timer: float = 0.0

var noise_t: float
var t: float
var play_in_editor: bool = false

var physics_query_params: PhysicsShapeQueryParameters2D


func _ready() -> void:
	physics_query_params = PhysicsShapeQueryParameters2D.new()
	physics_query_params.collide_with_areas = true
	physics_query_params.collide_with_bodies = false
	physics_query_params.collision_mask = 2
	physics_query_params.shape = projectile.shape

	if projectile:
		_update_projectile(projectile)


func _physics_process(delta: float) -> void:
	if (not play_in_editor) and Engine.is_editor_hint():
		return
	
	if (abs(global_position.x) > ARENA_WIDTH / 2.0 or abs(global_position.y) > ARENA_HEIGHT / 2.0) and projectile.destroy_out_of_bounds:
		destroy()

	_process_collision()

	life_timer += delta
	if life_timer > projectile.lifetime:
		destroy()

	t += delta * movement.frequency
	velocity += movement.acceleration * delta
	global_velocity += movement.global_acceleration * delta
	global_position += (noise_velocity + \
		velocity.rotated(rotation) + \
		global_velocity + \
		(movement.wave_axis * movement.amplitude * cos(t)).rotated(rotation)) * delta

	rot_speed += movement.rotational_accel * delta
	rotation += rot_speed * delta


func _process_collision() -> void:
	_process_collision_result(_get_collision_result())


func _get_collision_result() -> Array[Dictionary]:
	physics_query_params.transform = global_transform
	return get_world_2d().direct_space_state.intersect_shape(physics_query_params, 1)


func _process_collision_result(collision_result: Array[Dictionary]) -> void:
	if collision_result.size() == 0 or Engine.is_editor_hint(): return
	var hitbox: Hitbox2D = collision_result[0]["collider"]
	hitbox.hit(self)
	if not projectile.piercing:
		destroy()


func _update_projectile(new_proj: Projectile) -> void:
	movement = new_proj.movement_pattern
	rot_speed = movement.rotation_speed
	velocity = Vector2(movement.initial_speed, 0)
	texture = new_proj.texture


func destroy() -> void:
	queue_free()