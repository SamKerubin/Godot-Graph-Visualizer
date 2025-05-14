@tool
extends NodeData
##@experimental: This class is currently under development, stay tunned with the constants updates to see
## future changes 
class_name SceneData

var _scene_properties: ScenePropertyReference

func _init(path_or_uid: String) -> void:
	_scene_properties = ScenePropertyReference.new()
	super._init(path_or_uid)

#region Getters
func get_properties() -> ScenePropertyReference:
	return _scene_properties

func serialize() -> Dictionary:
	var scene_data: Dictionary = super.serialize()
	scene_data.merge(_scene_properties.get_properties())

	return scene_data
#endregion
