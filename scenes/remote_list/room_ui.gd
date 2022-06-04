extends Control

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
const schemas = preload("res://scenes/remote_list/schemas.gd")

const PlayerCell = preload("res://scenes/remote_list/player_cell.tscn")

var room: colyseus.Room

var _ready_state = 0
var _ready_button: Button

var _on_players_handler
var _on_state_handler

# Called when the node enters the scene tree for the first time.
func _ready():
	_ready_button = $menu/ready
	var state: schemas.RoomState = room.get_state()
	_on_players_handler = funcref(self, "_on_players")
	_on_state_handler = funcref(self, "_on_state")
	state.listen("players:change").on(_on_players_handler)
	state.listen(":replace").on(_on_state_handler)

func _exit_tree():
	var state: schemas.RoomState = room.get_state()
	state.listen("players:change").off(_on_players_handler)
	state.listen("players:change").off(_on_state_handler)

func _on_players(players: colyseus.MapSchema):
	_reload(players)

func _reload(players: colyseus.MapSchema):
	var list = $list/box
	for child in list.get_children():
		child.queue_free()
	var keys = players.keys()
	for key in keys: 
		var player: schemas.PlayerSchema = players.at(key)
		var player_cell = PlayerCell.instance()
		player_cell.player = player
		list.add_child(player_cell)
		if key == room.session_id:
			_state_changed(player)
			player_cell.connect("state_change", self, "_state_changed")

func _on_exit_pressed():
	room.leave()
	
	get_tree().change_scene("res://scenes/remote_list/remote_list.tscn")
	queue_free()

func _on_ready_pressed():
	if _ready_state == 0:
		room.send('ready', 1)
	else:
		room.send('ready', 0)

func _state_changed(player):
	_ready_state = player.state
	match _ready_state:
		0: 
			_ready_button.text = 'Prepare'
		1:
			_ready_button.text = 'Unprepare'

func _on_state(current, new_value, key):
	if key == "state":
		if new_value == 1:
			var scene_pack = load("res://stages/stage01/scene.tscn")
			var scene = scene_pack.instance()
			scene.room = room
			var state: schemas.RoomState = room.get_state()
			var players: colyseus.MapSchema = state.players
			
			var player_pack = load("res://characters/Atlas/atlas.tscn")
			var config = Defines.load_config()
			
			var keys = players.keys()
			var idx = 0
			for key in keys: 
				var player: schemas.PlayerSchema = players.at(key)
				var player_scene = player_pack.instance()
				player_scene.get_cmds().resource = config.commands_1p
				player_scene.get_cmds().refresh()
				scene.set_player(player_scene, idx)
				idx += 1
				
			get_parent().add_child(scene)
			queue_free()
