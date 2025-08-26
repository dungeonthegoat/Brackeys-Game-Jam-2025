extends Node2D


@export var shaker: Shaker2D


func _ready() -> void:
	Game.player_damaged.connect(_player_hit)


func _player_hit(_damage: int) -> void:
	if not Settings.shake_toggle: return
	shaker.shake()