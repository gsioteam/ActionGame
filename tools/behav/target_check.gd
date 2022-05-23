extends "res://addons/action_behavior_tree/lib/probable.gd"


func test(tick: Tick):
	return tick.global_context.has("target") and .test(tick) 
