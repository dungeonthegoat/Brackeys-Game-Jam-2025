extends Node


var master_volume: float = 1.0:
	set(vol):
		master_volume = vol
		_update_bus_volume("Master", vol)
var music_volume: float = 1.0:
	set(vol):
		music_volume = vol
		_update_bus_volume("Music", vol)
var sfx_volume: float = 1.0:
	set(vol):
		sfx_volume = vol
		_update_bus_volume("SFX", vol)
var ui_volume: float = 1.0:
	set(vol):
		ui_volume = vol
		_update_bus_volume("UI", vol)
var shake_toggle: bool = true


func _update_bus_volume(bus_name: StringName, volume: float) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(idx, volume)
	print(AudioServer.get_bus_volume_db(idx))