extends "res://addons/action_behavior_tree/lib/action.gd"


export(Vector2) var speed = Vector2(0,0)

func action(tick):
	var target: Character = tick.target
	tick.frame_context.speed += speed
	return Status.SUCCEED
