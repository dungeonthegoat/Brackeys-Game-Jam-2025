class_name Hitbox2D
extends Area2D


signal hurt(amount: int)


var timer: Timer


@export var i_frame_time: float
@export var blinking_anim_player: AnimationPlayer


func _ready() -> void:
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_timeout)
	add_child(timer)
	area_entered.connect(_area_entered)


func _area_entered(area: Area2D) -> void:
	if not timer.is_stopped(): return
	if area is not Projectile2D: return
	
	var proj_2d: Projectile2D = area as Projectile2D

	hurt.emit(proj_2d.projectile.damage)
	blinking_anim_player.play("blinking")
	timer.start(i_frame_time)

	if not proj_2d.projectile.piercing:
		proj_2d.destroy()


func _timeout() -> void:
	blinking_anim_player.play("RESET")
	if get_overlapping_areas().size() > 0:
		for area: Area2D in get_overlapping_areas():
			_area_entered(area)