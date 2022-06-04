extends "res://addons/action_behavior_tree/lib/action.gd"

const Defines = preload("res://tools/defines.gd")

export(Vector2) var speed = Vector2(0,0)
export(Defines.Face) var face
export(bool) var air_move = false

class Data:
	var walk_anim: String
	var turn_anim: String
	var turn_frames: int

var data: Data
var _frame_counter = 0;

func action(tick):
	var target: Character = tick.target
	target.current_action = self
	var turning = _frame_counter < data.turn_frames and face != Defines.Face.None and target.face != face
	
	if not air_move:
		if turning:
			target.animate(data.turn_anim)
		else:
			target.animate(data.walk_anim)
		if not turning and face != Defines.Face.None:
			target.set_face(face)
	if turning:
		_frame_counter += 1
	else:
		tick.frame_context.speed += speed
	return Status.SUCCEED

func reset():
	.reset()
	_frame_counter = 0
