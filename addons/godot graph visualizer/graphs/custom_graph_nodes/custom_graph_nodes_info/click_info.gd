@tool
extends Control

# Aside with all the relations of the node
# Aside with the documentation written within the editor_description property and also doc strings
# Maybe? Aside with special comments like "TODO", "FIXME", "NOTE", etc

const _NODE_RELATIONS_INTERFACE: PackedScene = preload("uid://7co4xgyxcqa8")
const _NODE_DOCUMENTATION_INTERFACE: PackedScene = preload("uid://b4exklskakecf")

@onready var node_name: RichTextLabel = $Panel/NodeName

var _documentation_formatter: DocumentationFormatter

func _ready() -> void:
	_documentation_formatter = DocumentationFormatter.new()
