extends "res://addons/action_behavior_tree/lib/action.gd"

export(String) var anim_name = "idle"

func action(tick: Tick):
	tick.target.animate(anim_name)
	return Status.SUCCEED

