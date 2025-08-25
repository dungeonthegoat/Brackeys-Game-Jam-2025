extends GridContainer


const HEART_ICON: PackedScene = preload("res://ui/heart/heart.tscn")


var hearts: Array[HeartIcon]


func _ready() -> void:
	Game.player_max_health_changed.connect(func(new_max_health: int) -> void: refresh_hearts(new_max_health, Game.player_health))
	Game.player_health_changed.connect(func(new_health: int) -> void: _update_hearts(new_health))

	refresh_hearts(Game.player_max_health, Game.player_health)


func refresh_hearts(max_health: int, health: int) -> void:
	hearts.clear()
	for child: Node in get_children():
		child.queue_free()
	
	for idx: int in range(ceil(max_health / 2.0)):
		var heart: HeartIcon = HEART_ICON.instantiate()
		hearts.append(heart)
		add_child(heart)
	
	_update_hearts(health)


func _update_hearts(health: int) -> void:
	for idx: int in range(hearts.size()):
		var heart: HeartIcon = hearts[idx]
		var val: float = health / 2.0 - idx
		if val <= 0:
			heart.state = HeartIcon.State.EMPTY
		elif val == 0.5:
			heart.state = HeartIcon.State.HALF
		else:
			heart.state = HeartIcon.State.FULL