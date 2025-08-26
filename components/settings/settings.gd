class_name SettingsMenu
extends Control


@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var ui_slider: HSlider
@export var shake_toggle: CheckButton


func _ready() -> void:
	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sfx_slider.value = Settings.sfx_volume
	ui_slider.value = Settings.ui_volume
	shake_toggle.button_pressed = Settings.shake_toggle

	shake_toggle.toggled.connect(_shake_toggled)
	master_slider.value_changed.connect(_master_volume_changed)
	music_slider.value_changed.connect(_music_volume_changed)
	sfx_slider.value_changed.connect(_sfx_volume_changed)
	ui_slider.value_changed.connect(_ui_volume_changed)


func _shake_toggled(value: bool) -> void:
	Settings.shake_toggle = value


func _master_volume_changed(volume: float) -> void:
	Settings.master_volume = volume


func _music_volume_changed(volume: float) -> void:
	Settings.music_volume = volume


func _sfx_volume_changed(volume: float) -> void:
	Settings.sfx_volume = volume


func _ui_volume_changed(volume: float) -> void:
	Settings.ui_volume = volume