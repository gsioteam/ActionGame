tool
extends Node
const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
const schemas = preload("res://scenes/remote_list/schemas.gd")
const RemoteData = preload("res://tools/controllers/remote_data.gd")

class_name GameScene

export (float) var gravity = 0.98
export (float) var rot = 10

var allies: Array = []
var enemies: Array = []

var camera: Spatial
var interface: Control

var room: colyseus.Room
var running: bool setget set_running, get_running
var frame_counter = 0
var frame: int setget , get_frame

static func current(var node: Node) -> GameScene:
	var GameScene = load("res://scenes/game_scene.gd") 
	while true:
		if node == null:
			return null
		if node is GameScene:
			return node as GameScene
		node = node.get_parent()
	return null

static func my_path(var node: Node) -> NodePath:
	return current(node).get_path_to(node)

static func my_node(var node, var path) -> Node:
	if path.empty():
		return null
	return current(node).get_node(path)

func _ready():
	camera = $camera
	interface = $interface
	
	if room != null:
		self.running = false
		yield(get_tree(), "idle_frame")
		var allies = []
		for ally in self.allies:
			allies.append(RemoteData.get_character_data(ally))
		var enemies = []
		for enemy in self.enemies:
			enemies.append(RemoteData.get_character_data(enemy))
		var map = {
			"allies": allies,
			"enemies": enemies,
		}
		room.send("scene_ready", map)
		room.on_message("ping").on(funcref(self, "_on_ping"))

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

var ready_to_sycn = false
func _physics_process(delta):
	if room != null and !self.running:
		var state: schemas.RoomState = room.get_state()
		var keys = state.characters.keys()
		if state.state == 2 and keys.size() > 0:
			print(keys)
			for path in keys:
				var child = get_node(path)
				child.setup_remote(room, state.characters.at(path))
			self.running = true
			ready_to_sycn = true
	if self.running:
		frame_counter += 1

func _on_process_physics_process(delta):
	if ready_to_sycn:
		var data = []
		for ch in allies:
			var char_data = ch.controller.get_character_data()
			if char_data != null:
				data.append(char_data)
		for ch in enemies:
			var char_data = ch.controller.get_character_data()
			if char_data != null:
				data.append(char_data)
		
		room.send("sync", {
			"data": data
		})

func get_frame():
	return frame_counter

func _on_ping(data):
	room.send("ping_echo", data)
