@tool
extends Panel

@onready var documentation: RichTextLabel = $VScrollBar/Documentation

var _documentation_formatter: DocumentationFormatter

func _ready() -> void:
	_documentation_formatter = DocumentationFormatter.new()

func show_formatted_documentation(doc: String) -> void:
	documentation.text = _documentation_formatter.format_text(doc)
