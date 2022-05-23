extends "res://addons/action_behavior_tree/lib/action.gd"

class GotoRunner:
	var position: Vector3
	
	signal completed
	

export (float) var distance = 5
export (float) var speed = 0.2
export (int) var max_frame = 120

var _runner: GotoRunner

func action(tick: Tick):
	var this: Character = tick.target
	var target: Character = tick.global_context.target
	var this_pos = this.global_transform.origin
	var target_pos = target.global_transform.origin
	if target.face == Defines.Face.Left:
		target_pos += Vector3(distance, 0, 0)
	else:
		target_pos -= Vector3(distance, 0, 0)
	
	_runner = GotoRunner.new()
	_runner.position = target_pos
	yield(_runner, "completed")
	
	return Status.SUCCEED

func running(tick: Tick, frame: int):
	if frame > max_frame:
		_runner.emit_signal("completed")
		return
	var this: Character = tick.target
	var target: Character = tick.global_context.target
	var this_pos = this.global_transform.origin
	var target_pos = target.global_transform.origin
	
	if this_pos.distance_to(_runner.position) < 0.8 or target_pos.distance_to(_runner.position) < 1: 
		_runner.emit_signal("completed")
	else:
		if abs(target_pos.x - this_pos.x) > 0.3:
			var face
			if target_pos.x > this_pos.x:
				face = Defines.Face.Right
			else:
				face = Defines.Face.Left
			this.set_face(face)
			
		
		var move_speed
		if this_pos.distance_to(target_pos) < 1:
			var nag = 1
			if _runner.position.x < this_pos.x:
				nag = -1
			var ss = speed / 1.414
			if this_pos.z < target_pos.z:
				move_speed = Vector3(ss * nag, 0, -ss)
			else:
				move_speed = Vector3(ss * nag, 0, ss)
		else:
			move_speed = (_runner.position - this_pos)
			move_speed.y = 0
			move_speed = move_speed.normalized() * speed
		
		this.set_move_speed(move_speed, true)
		tick.target.animate("walk")
	
	pass
