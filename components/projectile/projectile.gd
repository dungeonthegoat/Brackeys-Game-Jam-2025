@icon("res://components/projectile/projectile.svg")
class_name Projectile
extends Resource


enum TargetGroup {
    ENEMY,
    PLAYER
}


@export var destroy_out_of_bounds: bool = true
## The sprite of the projectile, facing rightward.
@export var texture: Texture2D

## The amount of time (in seconds) the projectile is alive for.
@export_range(1, 10, 0.001, "or_greater", "or_less", "suffix:s") var lifetime: float = 10.0

@export_group("Damage")
## The amount of damage this projectile does.
@export_range(0, 4, 1, "or_greater", "suffix:dmg") var damage: int = 1

## The group of entities which this projectile can damage.
@export var target_group: TargetGroup = TargetGroup.PLAYER

## Whether or not the projectile persists after damaging an entity.
@export var piercing: bool = false

## The size of the hitbox, in px.
@export var size: Vector2i = Vector2i(16, 16)


@export_group("Movement")
## The movement pattern for the projectile.
@export var movement_pattern: ProjectileMovementPattern