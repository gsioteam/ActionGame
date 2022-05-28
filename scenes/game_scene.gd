tool
extends Node

class_name GameScene

export (float) var gravity = 0.98
export (float) var rot = 10

var allies: Array = []
var enemies: Array = []

var camera: Spatial
var interface: Control

static func current(var node: Node) -> GameScene:
	var GameScene = load("res://scenes/game_scene.gd") 
	while true:
		if node == null:
			return null
		if node is GameScene:
			return node as GameScene
		node = node.get_parent()
	return null

func _ready():
	camera = $camera
	interface = $interface

func _get_configuration_warning():
	if $camera == null:
		return "No camera found."
	if $interface == null:
		return "No interface found."
	return ""

func set_player(player: Spatial, at: int):
	add_child(player)
	var trans = Transform.IDENTITY
	var pos: Spatial = $characters.get_child(at)
	trans.origin = pos.transform.origin
	player.transform = trans
	var char_ui = $interface/chars.get_child(at)
	char_ui.target = player
