extends Control

const ConfigPath = "user://config.tres"

export (Resource) var default_config

var config


# Called when the node enters the scene tree for the first time.
func _ready():
	if ResourceLoader.exists(ConfigPath):
		config = ResourceLoader.load(ConfigPath)
	else:
		config = default_config

func _on_menu_pressed():
	var scene_pack = load("res://scenes/menu/input_menu.tscn")
	var scene = scene_pack.instance()
	scene.config = config
	get_parent().add_child(scene)
	queue_free()

func _on_start_pressed():
	var scene_pack = load("res://stages/stage01/scene.tscn")
	var scene = scene_pack.instance()
	var player_pack = load("res://characters/Atlas/atlas.tscn")
	var player = player_pack.instance()
	player.get_cmds().resource = config.commands_1p
	player.get_cmds().refresh()
	scene.set_player(player, 0)
	modulate = Color.transparent
	get_parent().add_child(scene)
	queue_free()