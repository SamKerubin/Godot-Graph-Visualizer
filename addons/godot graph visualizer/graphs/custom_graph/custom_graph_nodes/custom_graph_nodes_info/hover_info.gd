@tool
extends Panel

@onready var incoming: RichTextLabel = $Incoming
@onready var outgoing: RichTextLabel = $Outgoing

var initialized: bool = false

func initialize(incoming_rel: int, outgoing_rel: int) -> void:
	if not initialized:
		initialized = true

		incoming.text = "Incoming: %s" % str(incoming_rel)
		outgoing.text = "Outgoing: %s" % str(outgoing_rel)
