extends "res://tools/behav/ext_action.gd"

var _speed
var _frame_count
var _hurt_data: AttackData.Information

const _anims = ["hurt", "pain1", "pain2", "pain3", "pain4"]

export (int) var pause_frame = 6
export (String) var hitbox = "allybox"

var _pause_count = 0
var _current_target

var animations
var anim_index = -1

var attacked = []
export (Resource) var attack_data

func action(tick):
	var target: Character = tick.target
	target.set_key_position()
	target.state = Defines.CharacterState.Launched
	attacked = [target]
	
	if animations == null:
		animations = []
		for an in _anims:
			if target.get_anim().has_animation(an):
				animations.append(an)
	
	var hurt_data = target.get_hurt_data()
	_hurt_data = hurt_data
	var frames = int(hurt_data.power * 2.8)
	var cur_anim
	if animations.size() > 1:
		anim_index = (anim_index + 1) % animations.size()
		cur_anim = animations[anim_index]
	elif animations.empty():
		cur_anim = "hurt"
	else:
		cur_anim = animations[0]
	
	target.queue_animate([cur_anim, "launched"])
	if _hurt_data.relative_point == null:
		_speed = hurt_data.direction * hurt_data.power / 30
		_speed.x = -_speed.x
	else:
		var target_pos = _hurt_data.relative_point.global_transform.origin
		var grabbed_pos = target.get_grabbed_point().global_transform.origin
		var body_pos = target.global_transform.origin
		target_pos = body_pos - grabbed_pos + target_pos
		var dir = target_pos - body_pos
		_speed = dir * hurt_data.power / 3
		_speed.x = min(1, max(-1, _speed.x))
		_speed += hurt_data.direction
	_frame_count = frames
	_pause_count = pause_frame * hurt_data.power / 24
	if _hurt_data.attack_type == AttackData.AttackType.Throw:
		_pause_count = 0
	_current_target = target
	target.set_move_speed(_speed, _hurt_data.relative_point != null)
	ext_data = {
		"speed_x": _speed.x,
		"speed_y": _speed.y,
		"speed_z": _speed.z,
		"frames": _frame_count,
		"pause": _pause_count,
	}
	yield(wait(frames + _pause_count), "completed")
	get_node("../wake").require_focus()

func running(tick: Tick, frame: int):
	var target = tick.target
	target.current_action = self
	#if _hurt_data.run_count >= 1:
	if _pause_count > 0:
		_pause_count -= 1
		if not target.paused:
			target.pause()
	else:
		if target.paused:
			target.resume()
	if target.paused:
		return
	if _speed.y < 0 and not target.air_test():
		get_node("../bounce").require_focus()
		return
	_speed.y -= target.gravity * 0.8
	target.set_move_speed(_speed, _hurt_data.relative_point != null)
	_hurt_data.run_count += 1
	if _hurt_data.launch_damage > 0:
		var info = attack_data.get_info()
		info.damage = _hurt_data.launch_damage
		target.attack([hitbox], attacked, info, info.spark_scene)

func reset():
	.reset()
	if _pause_count > 0:
		_current_target.resume()

