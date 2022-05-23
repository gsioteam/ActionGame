extends "res://tools/behav/attack.gd"


func running(tick: Tick, frame: int):
	.running(tick, frame)
	
	var target: Character = tick.target
	tick.global_context["dir"] = target.get_direction()
