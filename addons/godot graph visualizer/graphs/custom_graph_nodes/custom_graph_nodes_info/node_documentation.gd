@tool
extends Control

@onready var documentation: RichTextLabel = $Documentation

var _documentation_formatter: DocumentationFormatter

func _ready() -> void:
	_documentation_formatter = DocumentationFormatter.new()

func set_documentation(doc: String) -> void:
	documentation.text = _documentation_formatter.format_text(doc)

func clear_documentation() -> void:
	documentation.text = ""
