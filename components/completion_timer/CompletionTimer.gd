extends Area2D

signal change_state(state: bool)
signal challenge_failed()
signal challenge_complete()

@export var Countdown_Time: float

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = Countdown_Time
	timer.start()
	Game.player_died.connect(end_challenge)


func end_challenge() -> void:
	timer.stop()
	challenge_failed.emit()


func _on_timer_timeout() -> void:
	challenge_complete.emit()
