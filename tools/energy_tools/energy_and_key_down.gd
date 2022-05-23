extends "res://tools/behav/key_down.gd"


export (int) var energy_cost = 30

func test(tick):
	var target: Character = tick.target
	if target.can_cast(energy_cost):
		return .test(tick)
	return false
