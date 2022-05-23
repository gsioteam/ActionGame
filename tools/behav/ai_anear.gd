extends "res://addons/action_behavior_tree/lib/action.gd"

signal completed

export (float) var speed = 1
export (float) var max_frame = 120

func action(tick: Tick):
	yield(self, "completed")
	return Status.FAILED

func can_cancel(tick: Tick, frame: int):
	return true

func running(tick: Tick, frame):
	if frame > max_frame:
		emit_signal("completed")
	var target: Character = tick.global_context.target
	var this: Character = tick.target
	var target_pos = target.position_2d
	var this_pos = this.position_2d
	this.animate("walk")
	
	var face
	if target_pos.x > this_pos.x:
		face = Defines.Face.Right
	else:
		face = Defines.Face.Left
	this.set_face(face)
	
	if (abs(target_pos.y - this_pos.y) > 0.2):
		if abs(target_pos.x - this_pos.x) < 0.6:
			var neg = -1
			if target_pos.x < this_pos.x:
				neg = 1
			if target_pos.y > this_pos.y:
				this.set_move_speed(Vector3(speed * neg, 0, speed) / 1.414, true)
			else:
				this.set_move_speed(Vector3(speed * neg, 0, -speed) / 1.414, true)
		else:
			if target_pos.y > this_pos.y:
				this.set_move_speed(Vector3(0, 0, speed), true)
			else:
				this.set_move_speed(Vector3(0, 0, -speed), true)
	else:
		if target_pos.x < this_pos.x:
			this.set_move_speed(Vector3(-speed, 0, 0), true)
		else:
			this.set_move_speed(Vector3(speed, 0, 0), true)
		pass
	pass

