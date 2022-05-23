extends "res://addons/action_behavior_tree/lib/action.gd"

export (float) var maxnum_speed = 30

func action(tick: Tick):
	var target: Character = tick.target
	var gravity = target.gravity
	var fall_speed = target.v_speed
	fall_speed = max(fall_speed - gravity, -maxnum_speed)
	target.v_speed = fall_speed
	return Status.FAILED
