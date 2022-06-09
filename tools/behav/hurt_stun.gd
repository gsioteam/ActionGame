extends "res://tools/behav/ext_action.gd"

const Defines = preload("res://tools/defines.gd")

var _speed
var _frame_count
var _hurt_data: AttackData.Information

export (int) var pause_frame = 6
const _anims = ["hurt", "pain1", "pain2", "pain3", "pain4"]

var _pause_count = 0
var _current_target
var animations
var anim_index = -1

func action(tick):
	var target = tick.target
	target.set_key_position()
	target.current_action = self
	target.state = Defines.CharacterState.Pain
	if animations == null:
		animations = []
		for an in _anims:
			if target.get_anim().has_animation(an):
				animations.append(an)
	var hurt_data: AttackData.Information = target.get_hurt_data()
	_hurt_data = hurt_data
	var frames = int(hurt_data.power * 1.2 / target.gravity_scaling) 
	var cur_anim
	if animations.size() > 1:
		anim_index = (anim_index + 1) % animations.size()
		cur_anim = animations[anim_index]
	elif animations.empty():
		cur_anim = "hurt"
	else:
		cur_anim = animations[0]
	target.animate(cur_anim, true)
	_speed = hurt_data.direction * hurt_data.power / 60
	_speed.x = -_speed.x
	_speed.y = 0
	_frame_count = frames
	_pause_count = pause_frame * hurt_data.power / 24
	_current_target = target
	target.move_speed = _speed
	yield(wait(frames + _pause_count), "completed")
	get_node("../wake").require_focus()

func running(tick: Tick, frame: int):
	var target = tick.target
	#if _hurt_data.run_count >= 1:
	if _pause_count > 0:
		_pause_count -= 1
		if not target.paused:
			target.pause(_pause_count)
	else:
		if target.paused:
			target.resume()
	if target.paused:
		return
	_hurt_data.run_count += 1
	target.move_speed = _speed * (_frame_count - frame) / float(_frame_count)

func reset():
	.reset()
	if _pause_count > 0:
		_current_target.resume()
