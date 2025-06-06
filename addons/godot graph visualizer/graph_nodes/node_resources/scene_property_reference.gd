@tool
extends Resource
class_name ScenePropertyReference

## Class made to hold parsed scene instances and an attached script [class ScriptData]
## a scene may have

## Dictionary for saving each instance referenced[br]
## key: instance path, value: times referenced
var _scene_instances: Dictionary[String, int]
## Attached script a scene may have
## see [class ScriptData]
var _attached_script: ScriptData

#region Setters
## Adds an [param instance] path to [member _scene_instances][br]
## If [param instance] already exists, increments the times is referenced
func add_instance(instance: String) -> void:
	_scene_instances[instance] = _scene_instances.get(instance, 0) + 1

## If [member _attached_script] is null, sets a new one with value
## [param attached_script]
func set_attached_script(attached_script: ScriptData) -> bool:
	if _attached_script:
		push_error("Error: Already attached a script \'%s\'" % _attached_script.get_node_name())
		return false

	_attached_script = attached_script
 
	return true
#endregion

#region Getters
## Returns [member _attached_script]
func get_attached_script() -> ScriptData:
	return _attached_script

## Returns a wrapped dictionary holding the information of:[br]
## [member _attached_script][br]
## [member _scene_instances][br][br]
## if [member _attached_script] is null, sets the key of attached_script to an empty dict 
func get_properties() -> Dictionary:
	return {
		"attached_script": get_attached_script().serialize() if _attached_script else {},
		"instance": _scene_instances
	}
#endregion
