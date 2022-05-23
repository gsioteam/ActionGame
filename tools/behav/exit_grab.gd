extends "res://addons/action_behavior_tree/lib/if.gd"

export (int) var max_frame = 60

var _frame_count = 0

func tick(tick: Tick):
	_frame_count += 1
	return .tick(tick)

func test(tick):
	return _frame_count > max_frame

func reset():
	.reset()
	_frame_count = 0
