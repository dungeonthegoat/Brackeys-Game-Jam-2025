extends CharacterBody2D


@export var hitbox: Hitbox2D


func _ready() -> void:
    hitbox.hurt.connect(Game.hurt_player)