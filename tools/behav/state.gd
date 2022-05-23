extends "res://addons/action_behavior_tree/lib/action.gd"

export (Defines.CharacterState) var state

func action(tick: Tick):
	tick.target.state = state
	return Status.FAILED
