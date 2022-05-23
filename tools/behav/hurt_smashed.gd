extends "res://addons/action_behavior_tree/lib/action.gd"



func action(tick):
	tick.target.state = Defines.CharacterState.Launched
	return Status.SUCCEED
