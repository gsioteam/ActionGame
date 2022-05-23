extends "res://addons/action_behavior_tree/lib/if.gd"

const CommandManager = preload("res://addons/action_command/lib/command_manager.gd")

export var action: String;

var _action_queue

func _ready():
	_action_queue = CommandManager.parse_command(action)

func test(tick):
	var target: Character = tick.target
	return _action_queue != null and target.command_match(_action_queue) != null

func debug_data():
	return {
		"action": action
	}
