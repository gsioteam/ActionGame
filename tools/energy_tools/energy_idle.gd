extends "res://tools/behav/idle.gd"

export (int) var regen_frames = 78
export (float) var regen_value = 0.5

func action(tick: Tick):
	.action(tick)
	
	if idle_frames > regen_frames:
		var target = tick.target
		target.energy = min(target.max_energy, target.energy + regen_value)

