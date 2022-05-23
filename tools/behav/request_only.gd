extends "res://addons/action_behavior_tree/lib/if.gd"

var _requested = false

func test(tick: Tick):
	if _requested:
		_requested = false
		return true
	return false

func _request_focus(child: BNode):
	if child.get_parent() == self:
		_requested = true
