class_name DropZone
extends Area2D


signal change_progress(amount: float)


@export_range(0.0, 1.0, 0.001) var progress_increment: float = 0.1
@export var deposit_time: float = 3.0


func _on_area_exited(area:Area2D) -> void:
	pass # Replace with function body.


func _on_area_entered(area:Area2D) -> void:
	pass # Replace with function body.
