class_name Hitbox2D
extends Area2D


signal hurt(amount: int)


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area: Area2D) -> void:
	if area is not Projectile2D: return
	var proj_2d: Projectile2D = area as Projectile2D

	hurt.emit(proj_2d.projectile.damage)

	if not proj_2d.projectile.piercing:
		proj_2d.destroy()