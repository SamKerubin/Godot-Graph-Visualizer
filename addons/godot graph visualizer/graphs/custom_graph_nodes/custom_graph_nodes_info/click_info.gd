@tool
extends Panel

# Aside with all the relations of the node
# Aside with the documentation written within the editor_description property and also doc strings
# Maybe? Aside with special comments like "TODO", "FIXME", "NOTE", etc

@onready var node_name: RichTextLabel = $NodeName

@onready var node_relations: Control = $NodeRelations
@onready var node_documentation: Control = $NodeDocumentation

@onready var relation_button: Button = $GridContainer/Relations
@onready var documentation_button: Button = $GridContainer/Documentation

var current_node: RelationData
var current_display: String = "relations"

func _ready() -> void:
	relation_button.pressed.connect(_on_relations_pressed.bind(relation_button.name.to_lower()))
	documentation_button.pressed.connect(_on_documentation_pressed.bind(
										documentation_button.name.to_lower()
										))

func set_current_node(node: RelationData) -> void:
	current_node = node
	node_name.text = "[font_size=70][b]%s[/b][/font_size]" % node.node_name
	node_relations.set_references(node.outgoing)
	node_documentation.set_documentation(node.documentation)

func change_view_to_relations() -> void:
	node_documentation.visible = false
	documentation_button.flat = false
	node_relations.visible = true
	relation_button.flat = true

func change_view_to_documentation() -> void:
	node_relations.visible = false
	relation_button.flat = false
	node_documentation.visible = true
	documentation_button.flat = true

func clear_current_node() -> void:
	current_node = null
	node_relations.clear_references()
	node_documentation.clear_documentation()

func _on_relations_pressed(display_clicked: String) -> void:
	if current_display == "relations":
		return

	current_display = display_clicked
	change_view_to_relations()

func _on_documentation_pressed(display_clicked: String) -> void:
	if current_display == "documentation":
		return

	current_display = display_clicked
	change_view_to_documentation()
