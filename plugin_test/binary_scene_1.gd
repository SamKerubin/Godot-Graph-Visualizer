extends Node2D
class_name BinaryScene1

const PATH: String = "res://plugin_test/Scene2.tscn"

const PATHS: Dictionary[String, String] = {
	"path_1": "res://plugin_test/Scene2.tscn"
}


var a: PackedScene = preload(PATH)
var b: PackedScene = load("res://plugin_test/Scene3.tscn")
var c: PackedScene = preload("res://plugin_test/Scene2.tscn")
var d: Node = c.instantiate()

# For later, but for now... Im going to test with variables a-d
var instance: Test2 = Test2.new()

var e: Node = preload(PATHS.path_1).instantiate()
var f: PackedScene = preload(instance.B)
var g: PackedScene = load(Test2.a)
var h: PackedScene = preload(PATHS["path_1"])
