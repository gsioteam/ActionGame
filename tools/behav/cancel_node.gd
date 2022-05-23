extends "res://addons/action_behavior_tree/lib/during_select.gd"

enum CancelType {
	Hit,
	NextAction,
	NextAndHit,
	FrameCount,
}

export(CancelType) var cancel_type = CancelType.Hit
export(int) var cancel_frames = 5

var attack_node
var _can_cancel = false

func _ready():
	attack_node = get_parent()

func start_action():
	_can_cancel = false

func can_cancel(tick: Tick, frame: int) -> bool:
	match cancel_type:
		CancelType.Hit:
			_can_cancel = attack_node.attacked.size() > 0 and attack_node.hit_counter > cancel_frames
		CancelType.FrameCount:
			_can_cancel = frame > cancel_frames
		CancelType.NextAction:
			_can_cancel = attack_node.process == null
		CancelType.NextAndHit:
			_can_cancel = attack_node.process == null and attack_node.attacked.size() > 0
	return _can_cancel

func tick(tick):
	if _can_cancel:
		return .tick(tick)
	return Status.FAILED
