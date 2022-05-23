extends Node

class_name GameScene

export (float) var gravity = 0.98

var allies: Array = []
var enemies: Array = []

static func current(var node: Node) -> GameScene:
	var GameScene = load("res://scenes/game_scene.gd") 
	while true:
		if node == null:
			return null
		if node is GameScene:
			return node as GameScene
		node = node.get_parent()
	return null
