extends "res://addons/action_behavior_tree/lib/action.gd"

func action(tick):
	tick.global_context.erase("target")
	return Status.FAILED
