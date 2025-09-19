@tool
extends Panel

@onready var references: ItemList = $References

func show_relations_in_itemlist(relations: Dictionary[RelationData, int]) -> void:
	references.clear()

	if relations.is_empty():
		references.add_item("No outgoing relations avialable")
		return

	for rel: RelationData in relations.keys():
		var rel_name: String = rel.node_name
		var amount: int = relations[rel]

		references.add_item("%s    --    %s %s referenced" % 
								[rel_name, str(amount), "times" if amount > 1 else "time"]
								)
