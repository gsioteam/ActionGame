extends "res://addons/action_behavior_tree/lib/action.gd"

class CurveRunner:
	signal completed
	
	var speed
	var acc
	
	func _init(s, a):
		speed = s
		acc = a
	
	func tick():
		speed -= acc
		if speed <= 0:
			speed = 0
			emit_signal("completed")

export(float) var vertical_speed = 8
export(float) var horizontal_speed = 6

var _runner: CurveRunner

func action(tick: Tick):
	var target: Character = tick.target
	var gravity = target.gravity
	var speed = Vector2(0, 0)
	var dir = target.get_direction()
	match (dir - 1) % 3:
		0: 
			speed.x = -1
		2: 
			speed.x = 1
	match (dir - 1) / 3:
		0:
			speed.y = 1
		2:
			speed.y = -1
	target.set_xy_speed(speed.normalized() * horizontal_speed, true)
	target.animate("jump")
	#_runner = CurveRunner.new(vertical_speed, gravity * 0.9)
	#yield(_runner, "completed")
	
	target.v_speed = vertical_speed
	
	return Status.FAILED

