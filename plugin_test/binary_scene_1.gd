extends Node2D
class_name BinaryScene1

const PATH: String = "res://plugin_test/Scene2.tscn"

var a: PackedScene = preload(PATH)
var b: PackedScene = load("res://plugin_test/Scene3.tscn")
var c: Node = preload(PATH).instantiate()
