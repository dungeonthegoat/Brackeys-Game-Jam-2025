@icon("res://components/projectile/projectile_movement.svg")
class_name ProjectileMovementPattern
extends Resource


@export_group("Linear Motion")
## The initial speed of the particle, in the direction that it is facing based off rotation.
@export var initial_speed: float

## The acceleration vector of the particle, relative to its rotation.
@export var acceleration: Vector2 = Vector2.ZERO

## The acceleration vector of the particle, in global coordinates.
@export var global_acceleration: Vector2 = Vector2.ZERO

@export_group("Rotational Motion")
## The initial rotational speed of the particle, in radians/sec.
@export var rotation_speed: float

## The rotational acceleration of the particle, in radians/sec^2.
@export var rotational_accel: float

@export_group("Sinusoidal Motion")
## The frequency of the sinusoidal movement, in sec^-1.
@export var frequency: float

## The amplitude of the sinusoidal movement, in px.
@export var amplitude: float

## The axis which the sinusoidal movement affects, relative to the direction vector of the projectile.
@export var wave_axis: Vector2 = Vector2.UP

@export_group("Noise")
@export var noise_freq: float
@export var noise_amp: float