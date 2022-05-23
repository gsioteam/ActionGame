extends "res://tools/behav/attack.gd"

export (int) var energy_cost = 30


func action(tick):
	tick.target.cast(energy_cost)
	return .action(tick)
