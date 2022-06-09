extends "res://addons/action_behavior_tree/lib/action.gd"


var ext_data
var run_id = 0
export (bool) var continuous = false

func _run_action(tick: Tick):
	run_id += 1
	return ._run_action(tick)

func get_action_node():
	return self

func has_ext(key):
	return ext_data is Dictionary and ext_data.has(key)
