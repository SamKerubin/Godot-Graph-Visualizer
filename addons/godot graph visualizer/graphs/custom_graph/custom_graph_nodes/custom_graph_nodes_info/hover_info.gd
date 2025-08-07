@tool
extends Control

@onready var scene_name: RichTextLabel = $SceneName
@onready var relations_amount: RichTextLabel = $Amount

var initialized: bool = false

func initialize(scn_name: String, amount: int) -> void:
	if not initialized:
		initialized = true

		scene_name.text = scn_name
		relations_amount.text = str(amount)
