extends "res://addons/action_behavior_tree/lib/action.gd"

export (float) var maxnum_speed = 30
export var rise_anim: String = "jump"
export var fall_anim: String = "fall"
export var fall_forward_anim: String = ""
export var fall_back_anim: String = ""

func action(tick: Tick):
	var target: Character = tick.target
	target.current_action = self
	var gravity = target.gravity
	var fall_speed = target.v_speed
	fall_speed = max(fall_speed - gravity, -maxnum_speed)
	target.v_speed = fall_speed
	var move_speed = target.move_speed
	if fall_speed < 0:
		if move_speed.x == 0:
			target.animate(fall_anim)
		else:
			var anim_name = fall_anim
			if move_speed.x < 0:
				anim_name = fall_back_anim
			else:
				anim_name = fall_forward_anim
			if not target.get_anim().has_animation(anim_name):
				anim_name = fall_anim
			target.animate(anim_name)
	else:
		target.animate(rise_anim)
	return Status.FAILED
