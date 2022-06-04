tool
extends Node
const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
const schemas = preload("res://scenes/remote_list/schemas.gd")

class_name GameScene

export (float) var gravity = 0.98
export (float) var rot = 10

var allies: Array = []
var enemies: Array = []

var camera: Spatial
var interface: Control

var room: colyseus.Room
var running: bool setget set_running, get_running

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
	
	if room != null:
		self.running = false
		yield(get_tree(), "idle_frame")
		var allies = []
		for ally in self.allies:
			allies.append(get_character_data(ally))
		var enemies = []
		for enemy in self.enemies:
			enemies.append(get_character_data(enemy))
		var map = {
			"allies": allies,
			"enemies": enemies,
		}
		room.send("scene_ready", map)

func _get_configuration_warning():
	if $camera == null:
		return "No camera found."
	if $interface == null:
		return "No interface found."
	return ""

func set_player(player: Spatial, at: int):
	var node_name = str("player_", at)
	if has_node(node_name):
		remove_child(get_node(node_name))
	player.name = node_name
	add_child(player, true)
	var trans = Transform.IDENTITY
	var pos: Spatial = $characters.get_child(at)
	trans.origin = pos.transform.origin
	player.transform = trans
	var char_ui = $interface/chars.get_child(at)
	char_ui.target = player
	char_ui.visible = true

func add_character(character):
	character.running = _running
	match character.type:
		Defines.CharaterType.Ally:
			allies.append(character)
		Defines.CharaterType.Enemy:
			enemies.append(character)

var _running = true
func set_running(v):
	if _running != v:
		_running = v
		for ch in allies:
			ch.running = v
		for ch in enemies:
			ch.running = v

func get_running():
	return _running

func get_character_data(character: KinematicBody):
	var pos = character.transform.origin
	
	var action = 'null'
	if character.current_action != null:
		action = str(character.get_path_to(character.current_action))
	
	return {
		"x": pos.x,
		"y": pos.y,
		"z": pos.z,
		"node": str(get_path_to(character)),
		"action": action,
	}

func _physics_process(delta):
	if room != null and !running:
		var state: schemas.RoomState = room.get_state()
		if state.state == 2:
			var keys = state.characters.keys()
			print(keys)
