extends "res://addons/action_behavior_tree/lib/if.gd"


func test(tick: Tick):
	var target: KinematicBody = tick.target
	return target.air_test();
