extends "res://addons/action_behavior_tree/lib/action.gd"

export(String) var action_name
export(bool) var reset_speed = true

var __target

func action(tick):
	var target: KinematicBody = tick.target
	__target = target
	target.current_action = self
	if reset_speed:
		target.set_xy_speed(Vector2.ZERO)
	var yield_state: GDScriptFunctionState = target.animate(action_name, true)
	yield(yield_state, "completed")
	# target.current_action = null
	return Status.SUCCEED

func next_phase(tick):
	pass

func stop_running():
	#if __target != null and __target.current_action == self:
	#	__target.current_action = null
	pass
