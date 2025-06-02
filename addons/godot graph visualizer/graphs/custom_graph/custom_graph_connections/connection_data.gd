@tool
extends Resource
class_name ConnectionData

var from: String
var to: String
var times_referenced: int
var attached_script: String

func serialize() -> Dictionary:
	return {
		"from": from,
		"to": to,
		"times_referenced": times_referenced,
		"attached_script": attached_script
	}
