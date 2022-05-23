extends "res://addons/action_behavior_tree/lib/action.gd"

export (float) var distance = 5
export (float) var speed = 0.2

func action(tick: Tick):
	var target: Character = tick.global_context.target
	var this: Character = tick.target
	var target_pos = target.position_2d
	var this_pos = this.position_2d
	
	if abs(target_pos.x - this_pos.x) > 0.3:
		var face
		if target_pos.x > this_pos.x:
			face = Defines.Face.Right
		else:
			face = Defines.Face.Left
		this.set_face(face)
	
	var dis = target_pos.distance_to(this_pos)
	if abs(dis - distance) > 1:
		if dis > distance:
			# anear
			var dir = (target_pos - this_pos).normalized() * speed
			this.set_move_speed(Vector3(dir.x, 0, dir.y), true)
			pass
		else:
			# away
			var dir = -(target_pos - this_pos).normalized() * speed
			this.set_move_speed(Vector3(dir.x, 0, dir.y), true)
			pass
		tick.target.animate("walk")
	else:
		tick.target.animate("idle")
	return Status.SUCCEED
