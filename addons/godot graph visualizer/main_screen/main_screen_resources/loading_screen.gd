@tool
extends Panel

## An UI class made to show a loading screen, thats it

@onready var spinning_sprite: Sprite2D = $Control/Sprite2D

func _process(delta: float) -> void:
	if spinning_sprite:
		spinning_sprite.rotate(PI * delta)
