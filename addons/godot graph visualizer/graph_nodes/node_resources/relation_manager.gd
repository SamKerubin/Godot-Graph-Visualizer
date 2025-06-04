@tool
extends Resource
class_name RelationManager

var relations: Array[RelationData]

func find_relation_with_name(name: String) -> RelationData:
	var index: int = relations.find(func(x: RelationData) -> bool:
		return x.node_name == name
	)

	if index == -1: return null

	return relations.get(index)
