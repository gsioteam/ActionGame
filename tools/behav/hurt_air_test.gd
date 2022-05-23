extends "res://addons/action_behavior_tree/lib/if.gd"

func test(tick: Tick):
	return tick.global_context.is_launcher
