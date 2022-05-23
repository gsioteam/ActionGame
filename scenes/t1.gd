extends "res://addons/action_behavior_tree/lib/action.gd"

export(Color) var color
export(String) var label

func action(tick: Tick):
	var target = tick.target
	target.set_color(color)
	target.set_label(label)
	yield(wait(30), "completed")
	return Status.SUCCEED
