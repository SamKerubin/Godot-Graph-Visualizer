@tool
extends Resource
## @experimental: This class is being used to test
class_name ScriptParser

const PRELOAD_RERERENCE: String = r"preload\(\s*(?:(\"(?:uid|res)://[^\"]+\")|\w+)\)"
const LOAD_REFERENCE: String = r"load\(\s*(?:(\"(?:uid|res)://[^\"]+\")|\w+)\)"
const INSTANTIATE_REFERENCE: String = \
	r"(?:(?:load|preload)\(\s*\"(?:(?:uid|res)://[^\"]+)\"\s*\)|\b\w+)\.instantiate\(\)"
const NEW_RESOURCE_REFERENCE: String = r"\b(\w+)\.new\(\)"
const VARIABLE_REFERENCE: String = \
	r"(?:var|const)\s+(%s)\s*=\s*(?:load|preload)\(\s*\"((?:uid|res)://[^\"]+)\"\s*\)"

enum ReferenceType {
	PRELOAD_REFERENCE,
	LOAD_REFERENCE,
	INSTANCE_REFERENCE,
	NEW_RESOURCE_REFERENCE,
	NULL_REFERENCE
}

static func parse_script(path: String) -> Dictionary[ReferenceType, Array]:
	return {}
