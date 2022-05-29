tool
extends Control

const KeyInputDialog = preload("res://addons/action_command/lib/key_input_dialog.gd")

var config

var _1p_up
var _1p_down
var _1p_left
var _1p_right
var _1p_a
var _1p_b
var _1p_c
var _1p_d

var _2p_up
var _2p_down
var _2p_left
var _2p_right
var _2p_a
var _2p_b
var _2p_c
var _2p_d

# Called when the node enters the scene tree for the first time.
func _ready():
	var commands_1p: CommandResource = config.commands_1p
	var commands_2p: CommandResource = config.commands_2p
	
	_1p_up = $vbox.find_node("1p_up")
	_1p_down = $vbox.find_node("1p_down")
	_1p_left = $vbox.find_node("1p_left")
	_1p_right = $vbox.find_node("1p_right")
	_1p_a = $vbox.find_node("1p_a")
	_1p_b = $vbox.find_node("1p_b")
	_1p_c = $vbox.find_node("1p_c")
	_1p_d = $vbox.find_node("1p_d")
	
	_2p_up = $vbox.find_node("2p_up")
	_2p_down = $vbox.find_node("2p_down")
	_2p_left = $vbox.find_node("2p_left")
	_2p_right = $vbox.find_node("2p_right")
	_2p_a = $vbox.find_node("2p_a")
	_2p_b = $vbox.find_node("2p_b")
	_2p_c = $vbox.find_node("2p_c")
	_2p_d = $vbox.find_node("2p_d")
	
	_1p_up.button_text = commands_1p.direction8.action_string()
	_1p_down.button_text = commands_1p.direction2.action_string()
	_1p_left.button_text = commands_1p.direction4.action_string()
	_1p_right.button_text = commands_1p.direction6.action_string()
	_1p_a.button_text = commands_1p.buttons[0].action_string()
	_1p_b.button_text = commands_1p.buttons[1].action_string()
	_1p_c.button_text = commands_1p.buttons[2].action_string()
	_1p_d.button_text = commands_1p.buttons[3].action_string()

	_2p_up.button_text = commands_2p.direction8.action_string()
	_2p_down.button_text = commands_2p.direction2.action_string()
	_2p_left.button_text = commands_2p.direction4.action_string()
	_2p_right.button_text = commands_2p.direction6.action_string()
	_2p_a.button_text = commands_2p.buttons[0].action_string()
	_2p_b.button_text = commands_2p.buttons[1].action_string()
	_2p_c.button_text = commands_2p.buttons[2].action_string()
	_2p_d.button_text = commands_2p.buttons[3].action_string()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_cancel_pressed()

func _on_cancel_pressed():
	var ret = ResourceSaver.save(Defines.ConfigPath, config)
	var scene_pack = load("res://ui/main_menu/main_menu.tscn")
	var scene = scene_pack.instance()
	get_parent().add_child(scene)
	queue_free()

func _on_button_pressed(btn):
	var session = KeyInputDialog.InputSession.new()
	yield($input.input_key(session), "completed")
	if session.confirmed and session.command_action != null:
		var commands_1p: CommandResource = config.commands_1p
		var commands_2p: CommandResource = config.commands_2p
		match btn:
			_1p_up:
				commands_1p.direction8 = session.command_action
			_1p_down:
				commands_1p.direction2 = session.command_action
			_1p_left:
				commands_1p.direction4 = session.command_action
			_1p_right:
				commands_1p.direction6 = session.command_action
			_1p_a:
				session.command_action.action_name = 'a'
				commands_1p.buttons[0] = session.command_action
			_1p_b:
				session.command_action.action_name = 'b'
				commands_1p.buttons[1] = session.command_action
			_1p_c:
				session.command_action.action_name = 'c'
				commands_1p.buttons[2] = session.command_action
			_1p_d:
				session.command_action.action_name = 'd'
				commands_1p.buttons[3] = session.command_action
				
			_2p_up:
				commands_2p.direction8 = session.command_action
			_2p_down:
				commands_2p.direction2 = session.command_action
			_2p_left:
				commands_2p.direction4 = session.command_action
			_2p_right:
				commands_2p.direction6 = session.command_action
			_2p_a:
				session.command_action.action_name = 'a'
				commands_2p.buttons[0] = session.command_action
			_2p_b:
				session.command_action.action_name = 'b'
				commands_2p.buttons[1] = session.command_action
			_2p_c:
				session.command_action.action_name = 'c'
				commands_2p.buttons[2] = session.command_action
			_2p_d:
				session.command_action.action_name = 'd'
				commands_2p.buttons[3] = session.command_action
		btn.button_text = session.command_action.action_string()
