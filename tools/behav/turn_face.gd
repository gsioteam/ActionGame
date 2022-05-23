extends "res://addons/action_behavior_tree/lib/action.gd"


func action(tick):
	var target: Character = tick.target
	if target.face == Defines.Face.Right:
		target.set_face(Defines.Face.Left)
	elif target.face == Defines.Face.Left:
		target.set_face(Defines.Face.Right)
	return Status.SUCCEED
