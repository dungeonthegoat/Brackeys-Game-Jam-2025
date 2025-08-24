@tool
@icon("res://components/projectile/projectile_spawner_2d.svg")
class_name ProjectileSpawner2D
extends Node2D


enum SpawnDirection {
	FACING_PLAYER,
	FACING_DIRECTION,
	FACING_CENTER
}

enum SequenceType {
	RANDOM,
	WRAP,
	PING_PONG
}


@export var spawn_size: Vector2
@export var edges_only: bool
@export var spawn_sequence: SequenceType = SequenceType.RANDOM
@export var spawn_sequence_freq: float = 0.5

## The projectile to spawn.
@export var projectile: Projectile

## Whether or not it is currently spawning.
@export var playing: bool = false:
	set(value):
		playing = value
		spawn_projectile()
		if value:
			spawn_timer.start()
		else:
			spawn_timer.stop()

## The direction which projectiles spawn facing.
@export var spawn_direction: SpawnDirection = SpawnDirection.FACING_DIRECTION

## The direction the projectile spawns at if spawn_direction is set to FacingDirection
@export var direction: Vector2 = Vector2.DOWN

@export_range(0, TAU, 0.01) var spread_angle: float = 0.0

@export var angle_sequence: SequenceType = SequenceType.RANDOM

@export var angle_sequence_freq: float = 0.5


@export var spawn_rate: float = 1.0:
	set(new_rate):
		spawn_rate = new_rate
		if spawn_timer:
			spawn_timer.wait_time = 1.0 / spawn_rate


var pos_seq: float = 0.0
var rot_seq: float = 0.0

var spawn_timer: Timer


func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.autostart = false
	spawn_timer.wait_time = 1.0 / spawn_rate
	add_child(spawn_timer)
	spawn_timer.timeout.connect(spawn_projectile)

	playing = true


func spawn_projectile() -> void:
	if not projectile: return

	var proj_2d: Projectile2D = Projectile2D.new()
	proj_2d.global_position = get_spawn_position()
	proj_2d.projectile = projectile
	proj_2d.play_in_editor = true

	match spawn_direction:
		SpawnDirection.FACING_PLAYER:
			var pos: Vector2 = Game.get_player_position()
			if pos != null:
				proj_2d.rotation = proj_2d.global_position.angle_to_point(pos)
		SpawnDirection.FACING_CENTER:
			proj_2d.rotation = proj_2d.global_position.angle_to_point(Vector2.ZERO)
		SpawnDirection.FACING_DIRECTION:
			proj_2d.rotation = direction.angle()

	proj_2d.rotation += get_proj_angle()

	get_parent().add_child(proj_2d)

	pos_seq += spawn_timer.wait_time * spawn_sequence_freq
	rot_seq += spawn_timer.wait_time * angle_sequence_freq

	if Engine.is_editor_hint():
		await get_tree().create_timer(projectile.lifetime).timeout
		if proj_2d: proj_2d.queue_free()


func get_spawn_position() -> Vector2:
	if not edges_only:
		match spawn_sequence:
			SequenceType.RANDOM:
				return global_position + Vector2(randf_range(-spawn_size.x / 2.0, spawn_size.x / 2.0), randf_range(-spawn_size.y / 2.0, spawn_size.y / 2.0))
			SequenceType.WRAP:
				return (fmod(pos_seq, 1.0) - 0.5) * spawn_size + global_position
			SequenceType.PING_PONG:
				return (abs(fmod(pos_seq + 1.0, 2.0) - 1.0) - 0.5) * spawn_size + global_position
	
	match spawn_sequence:
		SequenceType.RANDOM:
			match randi_range(0, 3):
				0:
					return global_position + Vector2(spawn_size.x / 2.0, randf_range(-spawn_size.y / 2.0, spawn_size.y / 2.0))
				1:
					return global_position + Vector2(-spawn_size.x / 2.0, randf_range(-spawn_size.y / 2.0, spawn_size.y / 2.0))
				2:
					return global_position + Vector2(randf_range(-spawn_size.x / 2.0, spawn_size.x / 2.0), spawn_size.y / 2.0)
				3:
					return global_position + Vector2(randf_range(-spawn_size.x / 2.0, spawn_size.x / 2.0), -spawn_size.y / 2.0)
		SequenceType.WRAP:
			var edge: int = floor(min(fmod(pos_seq, 1.0), 0.999) * 4.0)
			var prog: float = (4.0 * fmod(min(fmod(pos_seq, 1.0), 0.999), 0.25)) - 0.5
			match edge:
				0:
					return global_position + Vector2(spawn_size.x / 2.0, spawn_size.y * prog)
				1:
					return global_position + Vector2(-prog * spawn_size.x, spawn_size.y / 2.0)
				2:
					return global_position + Vector2(-spawn_size.x / 2.0, -spawn_size.y * prog)
				3:
					return global_position + Vector2(prog * spawn_size.x, -spawn_size.y / 2.0)
		SequenceType.PING_PONG:
			var edge: int = floor(min(abs(fmod(pos_seq + 1.0, 2.0) - 1.0), 0.999) * 4.0)
			var prog: float = (4.0 * fmod(abs(fmod(pos_seq + 1.0, 2.0) - 1.0), 0.25)) - 0.5
			match edge:
				0:
					return global_position + Vector2(spawn_size.x / 2.0, spawn_size.y * prog)
				1:
					return global_position + Vector2(-prog * spawn_size.x, spawn_size.y / 2.0)
				2:
					return global_position + Vector2(-spawn_size.x / 2.0, -spawn_size.y * prog)
				3:
					return global_position + Vector2(prog * spawn_size.x, -spawn_size.y / 2.0)
	
	return global_position


func get_proj_angle() -> float:
	match angle_sequence:
		SequenceType.RANDOM:
			return randf_range(-spread_angle / 2.0, spread_angle / 2.0)
		SequenceType.PING_PONG:
			return spread_angle * (abs(fmod(rot_seq + 1.0, 2.0) - 1.0) - 0.5)
		SequenceType.WRAP:
			return spread_angle * (fmod(rot_seq, 1.0) - 0.5)
	
	return 0.0


func play() -> void:
	pos_seq = randf()
	rot_seq = randf()
	playing = true


func stop() -> void:
	playing = false
