@tool
extends Resource
class_name DocumentationFormatter

## Class for formatting doc strings
## It supports:[br]
## - BBcode (by default)[br]
## - Markdown (later)[br]
## - HTML (later)[br]

func format_text(text: String) -> String:
	if text.is_empty():
		return "This scene does not have a provided description within" \
		+ "the property \'Editor Description\'"

	var documentation_tokenizer: DocumentationTokenizer = DocumentationTokenizer.new()
	var documentation_parser: DocumentationParser = DocumentationParser.new()
	var documentation_builder: DocumentationBuilder = DocumentationBuilder.new()

	var tokens: Array[AST.Token] = documentation_tokenizer.tokenize(text)
	var ast_root: AST.ASTNode = documentation_parser.parse(tokens)
	var formatted_text: String = documentation_builder.build_ast(ast_root)

	return formatted_text
