extends "res://tools/behav/ext_action.gd"

export(String) var anim_name = "idle"

func action(tick: Tick):
	tick.target.current_action = self
	tick.target.animate(anim_name)
	return Status.FAILED

