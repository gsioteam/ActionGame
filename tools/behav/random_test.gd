extends "res://addons/action_behavior_tree/lib/probable.gd"


var _cooldown = 0
export (int) var cooldown_frames = 30

func test(tick):
	if _cooldown <= 0:
		_cooldown = cooldown_frames
		return .test(tick)
	return false

func _physics_process(delta):
	if _cooldown > 0: 
		_cooldown -= 1
