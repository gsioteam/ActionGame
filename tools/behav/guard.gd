extends "res://addons/action_behavior_tree/lib/action.gd"

class_name Guard

export (String) var anim_name = "guard"
export (float, 0, 1) var guard_scaling = 0.1
export (int) var frames = 9

var _char
var _runner

class Runner:
	var frames_count = 0
	var min_frames
	var target_frames
	var released = false
	
	var _speed: Vector3
	var _speed_frames = 0
	var _speed_max = 0
	
	signal finished
	
	func _init(frames):
		target_frames = frames
		min_frames = frames
	
	var speed: Vector3 setget , get_speed
	
	func get_speed():
		if _speed_frames > 0:
			return _speed * _speed_frames / _speed_max
		else:
			return Vector3.ZERO
	
	func tick():
		frames_count += 1
		if frames_count >= target_frames and released:
			emit_signal("finished")
		if _speed_frames > 0:
			_speed_frames -= 1
	
	func increase(frames: int):
		target_frames = max(frames_count + frames, min_frames)
	
	func set_speed(speed: Vector3, frames: int):
		_speed = speed
		_speed_frames = frames
		_speed_max = frames

func action(tick: Tick):
	var target: Character = tick.target
	_char = target
	target.guard_action = self
	target.xy_speed = Vector2.ZERO
	target.animate(anim_name)
	_runner = Runner.new(frames)
	yield(_runner, "finished")
	return Status.SUCCEED

func running(tick: Tick, frame: int):
	var target: Character = tick.target
	if not target.get_cmds().is_press("c"):
		_runner.released = true
	_runner.tick()
	target.move_speed = _runner.speed
	
func stop_running():
	if _char != null:
		_char.guard_action = null

func test_guard(this: Character, from: Character, attack_info: AttackData.Information) -> bool:
	return this.face != attack_info.face

func attack_from(this: Character, from: Character, attack_info: AttackData.Information):
	_runner.increase(18)
	_runner.set_speed(Vector3(-1, 0, 0), 18)
	this.hp -= attack_info.damage * guard_scaling
	
