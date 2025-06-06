@tool
extends NodeData
class_name SceneData

## Class made to hold scene propertie references[br]
## See [class NodeData], [class ScenePropertyReference]

var _scene_properties: ScenePropertyReference

func _init(path_or_uid: String) -> void:
	"""
		Uses a path (or uid) to initialize the parent class NodeData
		
		Also, initialize the scene properties to a new instance
	"""

	_scene_properties = ScenePropertyReference.new()
	super._init(path_or_uid)

#region Getters
## Returns the scene properties this instance have
func get_properties() -> ScenePropertyReference:
	return _scene_properties

## Returns a dictionary holding the information of the scene[br]
## See [class NodeData] to understand which things are serialized
func serialize() -> Dictionary:
	var scene_data: Dictionary = super.serialize()
	scene_data.merge(_scene_properties.get_properties())

	return scene_data
#endregion
