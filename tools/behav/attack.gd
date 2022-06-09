extends "res://tools/behav/action.gd"

const CancelNode = preload("res://tools/behav/cancel_node.gd")

enum CancelType {
	Hit,
	PostAndHit,
	PostAction,
	FrameCount,
}

export(PoolStringArray) var hitboxes
export(Array, Resource) var attack_datas = []

var _phase = 0
var attacked = []
var _pause_counter = 0
var _target
var hit_counter = -1
var cancel_nodes = []

func _ready():
	for child in get_children():
		if child is CancelNode:
			cancel_nodes.append(child)

func action(tick):
	var target = tick.target
	target.current_action = self
	attacked.clear()
	_phase = 0
	hit_counter = -1
	for cancel_node in cancel_nodes:
		cancel_node.start_action();
	for path in hitboxes:
		var box: Area = tick.target.get_box(path)
		if box != null:
			box.visible = false
	return .action(tick)

func running(tick: Tick, frame: int):
	var target: KinematicBody = tick.target
	_target = target
	
	if hit_counter >= 0:
		hit_counter += 1
	var info = attack_info(tick)
	if info != null:
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

func reset():
	.reset()
	if _pause_counter > 0:
		_target.resume()
		_pause_counter = 0

func can_cancel(tick: Tick, frame: int):
	var ret = false
	for cancel_node in cancel_nodes:
		if cancel_node.can_cancel(tick, frame):
			ret = true
	return ret

func enter_subaction(tick: Tick, subaction):
	if _pause_counter > 0:
		_target.resume()
		_pause_counter = 0

func next_phase(tick: Tick):
	var size = attack_datas.size()
	if size > 0:
		_phase = (_phase + 1) % size

func attack_info(tick: Tick):
	if _phase < attack_datas.size():
		var attack_data = attack_datas[_phase]
		var point
		if not attack_data.relative_point_name.empty():
			var character = tick.target
			point = character.get_box(attack_data.relative_point_name)
		return attack_data.get_info(point)
