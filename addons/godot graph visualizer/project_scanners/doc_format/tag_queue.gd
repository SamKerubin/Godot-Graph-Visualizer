@tool
extends Resource
class_name TagQueue

var _tags: Array[String]

func enque(tag: String) -> void:
	_tags.append(tag)

func deque() -> String:
	return _tags.pop_front()

func is_empty() -> bool:
	return _tags.is_empty()
