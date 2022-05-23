extends "res://addons/action_behavior_tree/lib/link.gd"

func tick(tick: Tick):
	get_target().reset()
	return .tick(tick)
