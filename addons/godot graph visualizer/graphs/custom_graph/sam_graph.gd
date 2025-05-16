@tool
extends Control

var _nodes: Array[SceneNode]
var _connections: Array[ConnectionInfo]

# Hii, its me again :3
# I decided to make a custom version of GraphEdit and GraphNode

# Its going to be a little bit hard, but after thinking for... Maybe 2 days
# I think its better making a custom graph rather than using GraphEdit
# Its only for flexibility and some other implementations for my plugin!

# (And also, im going to learn alot with this!)

# :3

# Second message:
# I figured out that i was doing something wrong about my main idea, so...
# Unfortunately, i will take some time to re-think a little bit :c
# I might chage a lot of things...

func get_connection_with_start(starting_path: String) -> ConnectionInfo:
	for connection: ConnectionInfo in _connections:
		if connection.start == starting_path: return connection

	return null 
