extends ParallaxBackground


@export var scroll_speed: float


func _process(delta: float) -> void:
    scroll_base_offset.y += delta * scroll_speed