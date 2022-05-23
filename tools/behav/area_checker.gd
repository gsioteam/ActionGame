extends "res://addons/action_behavior_tree/lib/group_node.gd"

export (int) var max_frame = 120
export (float) var speed = 1

enum CheckerStatus {
	Anear,
	Attacking
}

var _status = CheckerStatus.Anear
var _frame_counter = 0

func tick(tick: Tick):
	if _frame_counter < max_frame:
		match _status:
			CheckerStatus.Anear:
				return _anear(tick)
			CheckerStatus.Attacking:
				return _attacking(tick)
		for child in get_children():
			if child is BNode:
				if child.enable:
					var ret = child.run_tick(tick)
					if ret != Status.FAILED:
						return ret
	else:
		reset()
	return Status.FAILED

func _anear(tick: Tick):
	var target: Character = tick.global_context.target
	var this: Character = tick.target
	var target_pos = target.position_2d
	var this_pos = this.position_2d
	
	if (abs(target_pos.y - this_pos.y) > 0.2):
		if target_pos.y > this_pos.y:
			this.set_move_speed(Vector3(0, 0, speed), true)
		else:
			this.set_move_speed(Vector3(0, 0, -speed), true)
	else:
		if target_pos.x < this_pos.x:
			this.set_move_speed(Vector3(-speed, 0, 0), true)
		pass
	
	pass

func _attacking(tick: Tick):
	pass

func reset():
	.reset()
	_frame_counter = 0
