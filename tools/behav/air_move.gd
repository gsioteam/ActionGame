extends "res://addons/action_behavior_tree/lib/during_select.gd"

export (float) var max_speed = 3
export (float) var acceleration = 0.3

func tick(tick: Tick):
	tick.frame_context.speed = Vector2.ZERO
	var ret = .tick(tick)
	var target: Character2D = tick.target
	var vec: Vector2 = tick.frame_context.speed
	vec = vec.normalized() * acceleration
	vec = target.xy_speed + vec
	if vec.length() <= max_speed:
		target.xy_speed = vec
	return Status.FAILED


