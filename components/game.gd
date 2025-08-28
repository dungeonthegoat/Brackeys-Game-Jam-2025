@tool
extends Node


enum ChallengeState {
	PASS,
	FAIL
}


signal player_damaged(amount: int)
signal player_healed(amount: int)
signal player_health_changed(new_health: int)
signal player_max_health_changed(new_max_health: int)
signal player_died()
signal challenge_ended(state: ChallengeState)


const STARTING_MAX_HEALTH: int = 10


var ChallengeLevel: Node2D
var current_progress: float


var player_health: int:
	set(new_health):
		player_health = new_health
		player_health_changed.emit(new_health)
var player_max_health: int = STARTING_MAX_HEALTH:
	set(new_max_health):
		player_max_health = new_max_health
		player_max_health_changed.emit(new_max_health)


func _ready() -> void:
	reset()


func get_player_position() -> Variant:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
	if player:
		return player.global_position
	
	return null


func reset() -> void:
	ChallengeLevel = get_tree().get_root().find_child("ChallengeLevel", true, false)
	if ChallengeLevel:
		ChallengeLevel.challenge_progress_changed.connect(progress_changed)
		ChallengeLevel.challenge_completed.connect(challenge_completed)
	
	player_max_health = STARTING_MAX_HEALTH
	player_health = STARTING_MAX_HEALTH


func progress_changed(new_progress: float) -> void:
	current_progress = new_progress


func challenge_completed() -> void:
	for signal_dict: Dictionary in ChallengeLevel.get_signal_list():
		print(signal_dict.name)


func hurt_player(amount: int) -> void:
	if player_health == 0: return

	player_health = clampi(player_health - amount, 0, player_max_health)
	player_damaged.emit(amount)
	
	if player_health == 0:
		player_died.emit()


func heal_player(amount: int) -> void:
	if player_health == 0: return
	
	player_health = clampi(player_health + amount, 0, player_max_health)
	player_healed.emit(amount)
