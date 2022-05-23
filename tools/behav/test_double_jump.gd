extends "res://tools/behav/key_down.gd"


func test(tick: Tick):
	var ret = .test(tick) && tick.target.v_speed < 1 && tick.global_context.get("double_jump_ready")
	if ret:
		 tick.global_context.double_jump_ready = false
	return ret
