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


@export var count: int = 1
@export var spawn_size: Vector2
@export var edges_only: bool

## The projectile to spawn.
@export var projectile: Projectile

@export var autoplay: bool = false

## Whether or not it is currently spawning.
@export var playing: bool = false:
	set(value):
		playing = value
		if value:
			tick()

## The direction which projectiles spawn facing.
@export var spawn_direction: SpawnDirection = SpawnDirection.FACING_DIRECTION

## The direction the projectile spawns at if spawn_direction is set to FacingDirection
@export var direction: Vector2 = Vector2.DOWN

@export_range(0, TAU, 0.01) var spread_angle: float = 0.0

@export var angle_sequence: SequenceType = SequenceType.RANDOM

@export var angle_sequence_freq: float = 0.5


@export_range(0.001, 5.0, 0.001, "suffix:sec") var spawn_time: float = 0.1


@export var oscillator: Node2D

@export var target_node: Node2D


var spawn_timer: float = 0.0


var rot_seq: float = 0.0


func _ready() -> void:
	playing = false
	if not Engine.is_editor_hint() and autoplay:
		playing = true


func tick() -> void:
	for idx: int in range(count):
		spawn_projectile(idx)


func _process(delta: float) -> void:
	if not playing:
		spawn_timer = 0
		return
	
	spawn_timer += delta

	if spawn_timer > spawn_time:
		for _idx: int in range(floor(spawn_timer / spawn_time)):
			tick()
		spawn_timer = fmod(spawn_timer, spawn_time)


func spawn_projectile(idx: int = 0) -> void:
	if not projectile or not get_parent(): return

	# print(Engine.get_frames_per_second())

	var proj_2d: Projectile2D = Projectile2D.new()
	if oscillator:
		proj_2d.global_position = oscillator.global_position
	else:
		proj_2d.global_position = get_spawn_position()
	proj_2d.projectile = projectile
	proj_2d.play_in_editor = true

	if not target_node:
		match spawn_direction:
			SpawnDirection.FACING_PLAYER:
				var pos: Vector2 = Game.get_player_position()
				if pos != null:
					proj_2d.rotation = proj_2d.global_position.angle_to_point(pos)
			SpawnDirection.FACING_CENTER:
				proj_2d.rotation = proj_2d.global_position.angle_to_point(Vector2.ZERO)
			SpawnDirection.FACING_DIRECTION:
				proj_2d.rotation = direction.angle()
	else:
		proj_2d.rotation = proj_2d.global_position.angle_to_point(target_node.global_position)
	

	proj_2d.rotation += get_proj_angle(rot_seq + (idx * (1.0 / count)))

	get_parent().add_child.call_deferred(proj_2d)

	rot_seq += spawn_time * angle_sequence_freq

	# if Engine.is_editor_hint():
	# 	await get_tree().create_timer(projectile.lifetime).timeout
	# 	if proj_2d: proj_2d.queue_free()


func get_spawn_position() -> Vector2:
	return global_position + Vector2(randf_range(-spawn_size.x / 2.0, spawn_size.x / 2.0), randf_range(-spawn_size.y / 2.0, spawn_size.y / 2.0))


func get_proj_angle(idx: float) -> float:
	match angle_sequence:
		SequenceType.RANDOM:
			return randf_range(-spread_angle / 2.0, spread_angle / 2.0)
		SequenceType.PING_PONG:
			return spread_angle * (abs(fmod(idx + 1.0, 2.0) - 1.0) - 0.5)
		SequenceType.WRAP:
			return spread_angle * (fmod(idx, 1.0) - 0.5)
	
	return 0.0


func play() -> void:
	rot_seq = randf()
	playing = true


func stop() -> void:
	playing = false
