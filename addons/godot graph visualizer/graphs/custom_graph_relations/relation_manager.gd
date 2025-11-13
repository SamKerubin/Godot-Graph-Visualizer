@tool
extends Resource
class_name RelationManager

var relations: Array[RelationData]

func find_relation_with_name(name: String) -> RelationData:
	for r: RelationData in relations:
		if r.node_name == name: return r

	return null

func update_relation(relation: RelationData) -> void:
	if relations.has(relation):
		var index: int = relations.find(relation)

		relations.set(index, relation)

		return

	relations.append(relation)
