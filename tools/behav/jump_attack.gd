extends "res://tools/behav/attack.gd"

export (Vector3) var begin_speed


func action(tick: Tick):
	var target = tick.target
	var ret = .action(tick)
	target.move_speed = begin_speed
	return ret

func running(tick: Tick, frame: int):
	.running(tick, frame)
	var target = tick.target
	target.move_speed.y -= target.gravity

func can_cancel(tick: Tick, frame: int):
	var target = tick.target
	return not target.air_test()
