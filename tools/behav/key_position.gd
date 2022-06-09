extends "res://addons/action_behavior_tree/lib/action.gd"


func action(tick: Tick):
	tick.target.set_key_position()
	return Status.SUCCEED
