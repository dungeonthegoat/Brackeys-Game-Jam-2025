extends Area2D

signal change_progress(amount: float)

@export var Progress_Increment: float
@export var Progress_Cooldown: float

@onready var timer: Timer = $Timer

var area_active: bool
var can_increment: bool


func _ready() -> void:
	timer.wait_time = Progress_Cooldown

func _physics_process(delta: float) -> void:
	if can_increment and area_active:
		change_progress.emit(Progress_Increment)
		can_increment = false
		timer.start()

func _on_area_entered(area: Area2D) -> void:
	area_active = true

func _on_area_exited(area: Area2D) -> void:
	area_active = false

func _on_timer_timeout() -> void:
	can_increment = true
