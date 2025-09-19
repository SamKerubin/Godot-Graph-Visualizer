@tool
extends Panel

# Aside with all the relations of the node
# Aside with the documentation written within the editor_description property and also doc strings
# Maybe? Aside with special comments like "TODO", "FIXME", "NOTE", etc

@onready var node_name: RichTextLabel = $NodeName

@onready var node_relations: Panel = $NodeRelations
@onready var node_documentation: Panel = $NodeDocumentation

var current_node: RelationData

func set_current_node(node: RelationData) -> void:
	current_node = node
	node_name.text = "[font_size=70][b]%s[/b][/font_size]" % node.node_name

func change_view_to_relations() -> void:
	node_documentation.visible = false
	node_relations.visible = true

	node_relations.show_relations_in_itemlist(current_node.outgoing)

func change_view_to_documentation() -> void:
	node_relations.visible = false
	node_documentation.visible = true

	node_documentation.show_formatted_documentation(current_node.documentation)

func clear_current_node() -> void:
	current_node = null
