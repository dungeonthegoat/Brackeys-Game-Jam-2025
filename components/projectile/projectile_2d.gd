@tool
@icon("res://components/projectile/projectile_2d.svg")
class_name Projectile2D
extends Area2D


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
var lifetime: float = 0.0

var noise_t: float
var t: float
var play_in_editor: bool = false

@onready var timer: Timer = Timer.new()
@onready var sprite: Sprite2D = Sprite2D.new()
@onready var collision: CollisionShape2D = CollisionShape2D.new()
@onready var rect: RectangleShape2D = RectangleShape2D.new()
@onready var noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	monitoring = false
	collision_mask = 0
	collision.shape = rect

	if lifetime != 0.0:
		timer.wait_time = lifetime
	else:
		timer.wait_time = projectile.lifetime
	
	timer.one_shot = true
	timer.autostart = true

	# var mat: CanvasItemMaterial = CanvasItemMaterial.new()
	# mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	# sprite.material = mat

	add_child(timer)
	add_child(sprite)
	add_child(collision)

	timer.timeout.connect(destroy)

	if projectile:
		_update_projectile(projectile)


func _process(delta: float) -> void:
	if (not play_in_editor) and Engine.is_editor_hint():
		return
	
	if (abs(global_position.x) > ARENA_WIDTH / 2.0 or abs(global_position.y) > ARENA_HEIGHT / 2.0) and projectile.destroy_out_of_bounds:
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

	if movement.noise_freq == 0 or movement.noise_amp == 0:
		return
	noise_t += delta * movement.noise_freq
	noise_velocity = movement.noise_amp * Vector2(noise.get_noise_2d(noise_t, noise_t + 100), noise.get_noise_2d(noise_t - 100, -noise_t))


func _update_projectile(new_proj: Projectile) -> void:
	if not sprite or not rect: return
	movement = new_proj.movement_pattern
	rot_speed = movement.rotation_speed
	velocity = Vector2(movement.initial_speed, 0)
	sprite.texture = new_proj.texture
	rect.size = new_proj.size

	match new_proj.target_group:
		Projectile.TargetGroup.PLAYER:
			collision_layer = 2
		Projectile.TargetGroup.ENEMY:
			collision_layer = 4


func destroy() -> void:
	queue_free()