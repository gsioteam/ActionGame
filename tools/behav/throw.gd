extends "res://tools/behav/attack.gd"

var _grab_data

export (Resource) var hit_data
export (bool) var is_seismic_toss = false
export (Vector3) var begin_speed

var finished = false

func action(tick: Tick):
	_phase = 0
	finished = false
	var character: Character = tick.global_context.grab_target
	var target: Character = tick.target
	var data = attack_info(tick)
	if data == null:
		return Status.FAILED
	_grab_data = data
	direct_attack(target, character, data)
	var ret = .action(tick)
	attacked = [character]
	if is_seismic_toss:
		target.move_speed = begin_speed
	return ret

func running(tick: Tick, frame: int):
	var target: Character = tick.target
	if is_seismic_toss and target.move_speed.y < 0 and not target.air_test():
		next_phase(tick)
		finished = true
	_target = target
	if is_seismic_toss and not target.is_paused():
		target.move_speed.y -= target.gravity
	if hit_data == null:
		return
	
	if hit_counter >= 0:
		hit_counter += 1
	if hit_data != null:
		var info = hit_data.get_info()
		var hit = target.attack(hitboxes, attacked, info, info.spark_scene)
		if hit:
			target.pause(info.self_pause)
			_pause_counter = info.self_pause
			hit_counter = 0
		else:
			if _pause_counter > 0:
				_pause_counter -= 1
				if _pause_counter == 0:
					target.resume()

func grab_data():
	return _grab_data

func next_phase(tick: Tick):
	.next_phase(tick)
	var character: Character = tick.global_context.grab_target
	var target: Character = tick.target
	var info = attack_info(tick)
	_grab_data = null
	direct_attack(target, character, info)

func direct_attack(this: Character, target: Character, attack_info):
	var scene: Spatial
	var spark_scene = attack_info.spark_scene
	if spark_scene != null:
		scene = spark_scene.instance()
		scene.set_face(this.face)
		this.get_parent().add_child(scene)
		scene.global_translate(target.get_grabbed_point().global_transform.origin)
	if attack_info.attack_type != AttackData.AttackType.Grab and attack_info.attack_type != AttackData.AttackType.Throw:
		this.pause(attack_info.self_pause)
	target.attack_from(this, attack_info)

func can_cancel(tick: Tick, frame: int):
	if is_seismic_toss:
		if finished:
			return .can_cancel(tick, frame)
		return false
	else:
		return .can_cancel(tick, frame)
