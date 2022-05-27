extends "res://addons/action_behavior_tree/lib/probable.gd"

var _cooldown = 0
export (int) var cooldown_frames = 60

func test(tick: Tick):
	if _cooldown <= 0:
		_cooldown = cooldown_frames
		return tick.global_context.has("target") and .test(tick) 
	return false

func _physics_process(delta):
	if _cooldown > 0: 
		_cooldown -= 1
