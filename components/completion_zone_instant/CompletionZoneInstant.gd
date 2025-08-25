extends Area2D

signal change_progress(amount: float)

@export var Progress_Increment: float

var area_active: bool


func _physics_process(delta: float) -> void:
	change_progress.emit(Progress_Increment)

func _on_area_entered(area: Area2D) -> void:
	area_active = true

func _on_area_exited(area: Area2D) -> void:
	area_active = false
