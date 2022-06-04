extends "res://addons/action_behavior_tree/lib/action.gd"



func action(tick):
	var target = tick.target
	target.current_action = self
	target.state = Defines.CharacterState.Launched
	return Status.SUCCEED
