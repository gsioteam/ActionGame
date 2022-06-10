extends "res://addons/action_behavior_tree/lib/switch.gd"

const Forward = preload("res://tools/behav/forward.gd")

export(float, 0, 40) var speed = 5
export(int, 0, 60) var turn_frames = 0
export(String) var walk_anim = "run"
export(String) var turn_anim = "turn"

var _turning_count = 0
var _turn_to_face

func _ready():
	self.index = 4
	var data = Forward.Data.new()
	data.walk_anim = walk_anim
	data.turn_anim = turn_anim
	data.turn_frames = turn_frames
	for subnode in get_children():
		if subnode is Forward:
			subnode.data = data

func tick(tick: Tick):
	var target = tick.target
	var dir
	if tick.frame_context.remote:
		dir = self.index + 1
	else:
		dir = target.get_direction()
		self.index = dir - 1
	var to_face
	match self.index % 3:
		0: 
			to_face = Defines.Face.Left
		1: 
			to_face = Defines.Face.None
		2:
			to_face = Defines.Face.Right
	
	if _turning_count > 0:
		_turning_count -= 1
		if _turning_count == 0:
			return Status.FAILED
		# print(_turning_count, " face ", to_face, " ",  _turn_to_face)
		if to_face == _turn_to_face:
			target.set_xy_speed(Vector2.ZERO)
			return Status.SUCCEED
		_turning_count = 0
	
	if to_face != Defines.Face.None:
		if to_face != target.face:
			_turn_to_face = to_face
			_turning_count = turn_frames
			target.set_face(_turn_to_face)
			target.set_xy_speed(Vector2.ZERO)
			target.animate(turn_anim)
			return Status.SUCCEED
	
	tick.frame_context.speed = Vector2.ZERO
	var ret = .tick(tick)
	var vec: Vector2 = tick.frame_context.speed
	vec = vec.normalized() * speed
	target.set_xy_speed(vec)
	return ret

func reset():
	.reset()
	_turning_count = 0
