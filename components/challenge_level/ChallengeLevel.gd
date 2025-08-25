extends Node2D

signal challenge_progress_changed(new_progress: float)
signal challenge_completed()

var current_challenge: Challenge
var progress: float


func _ready() -> void:
	for child: Area2D in get_tree().get_nodes_in_group("GradualZones"):
		child.change_progress.connect(increment_progress)
	for child: Area2D in get_tree().get_nodes_in_group("InstantZones"):
		child.change_progress.connect(increment_progress)


func increment_progress(amount: float) -> void:
	progress = clampf(progress+amount, 0.0, 1.0)
	challenge_progress_changed.emit(progress)
	if progress == 1.0:
		challenge_completed.emit()
	
