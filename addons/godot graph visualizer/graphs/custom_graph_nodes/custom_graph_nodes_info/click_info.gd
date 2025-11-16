@tool
extends Panel

# Aside with all the relations of the node
# Aside with the documentation written within the editor_description property and also doc strings
# Maybe? Aside with special comments like "TODO", "FIXME", "NOTE", etc

@onready var node_name := $MarginContainer/VBoxContainer/NodeName

@onready var node_relations := %NodeRelations
@onready var node_documentation := %NodeDocumentation

func set_current_node(node: RelationData) -> void:
	node_name.text = "[font_size=70][b]%s[/b][/font_size]" % node.node_name
	node_relations.set_references(node.outgoing)
	node_documentation.set_documentation(node.documentation)

func clear_current_node() -> void:
	node_name.text = ""
	node_relations.clear_references()
	node_documentation.clear_documentation()
