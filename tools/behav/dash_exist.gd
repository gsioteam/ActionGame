extends "res://addons/action_behavior_tree/lib/if.gd"

const Face = preload("res://tools/defines.gd").Face
export var reset_control: NodePath
export var reset_to: NodePath

func test(tick: Tick):
	var target: Character = tick.target
	var dir = target.get_direction()
	if target.face == Face.Right:
		if dir != 9 && dir != 6 && dir != 3:
			return true
	elif target.face == Face.Left:
		if dir != 7 && dir != 4 && dir != 1:
			return true
	return false

func reset():
	.reset()
	var control = get_node(reset_control)
	var to = get_node(reset_to)
	var children = control.get_children()
	control.index = children.find(to)
