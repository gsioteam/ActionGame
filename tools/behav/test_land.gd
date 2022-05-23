extends "res://addons/action_behavior_tree/lib/if.gd"



func test(tick: Tick):
	var target: Character = tick.target
	var ret = not target.air_test() and target.v_speed < 0
	if ret:
		tick.global_context.double_jump_ready = true
	return ret 
