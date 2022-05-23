extends "res://addons/action_behavior_tree/lib/if.gd"


func test(tick: Tick):
	var target: Character = tick.target
	var ret = target.air_test()
	if ret:
		target.v_speed = 0
	return ret
