@tool
extends Resource
class_name RelationManager

var relations: Array[RelationData]

func find_relation_with_name(name: String) -> RelationData:
	for r: RelationData in relations:
		if r.node_name == name: return r

	return null
