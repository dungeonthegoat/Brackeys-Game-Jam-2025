extends Node2D

signal change_state(state: bool)


@export_range(1.0, 60.0, 0.1, "or_greater", "suffix:sec") var countdown_time: float


@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = countdown_time
	timer.start()
	Game.player_died.connect(end_challenge)


func end_challenge() -> void:
	timer.stop()
	Game.challenge_ended.emit(Game.ChallengeState.FAIL)


func _on_timer_timeout() -> void:
	Game.challenge_ended.emit(Game.ChallengeState.PASS)
