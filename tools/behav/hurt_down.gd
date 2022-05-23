extends "res://addons/action_behavior_tree/lib/action.gd"

export(int) var min_frames = 60
export(int) var max_frames = 120

export(int) var cancel_frames = 45

var _canceled = false

func action(tick):
	var target: Character = tick.target
	target.state = Defines.CharacterState.Down
	var hurt_data: AttackData.Information = target.get_hurt_data()
	var frames = int(hurt_data.power * 1.2)
	frames -= hurt_data.run_count
	frames = clamp(frames, min_frames, max_frames)
	target.animate("down")
	target.move_speed = Vector3.ZERO
	_canceled = false
	if target.hp > 0:
		yield(wait(frames), "completed")
		if not _canceled:
			get_node("../rise").require_focus()
	else:
		target.dead()
		return Status.RUNNING

func can_cancel(tick: Tick, frame: int):
	return frame > cancel_frames

func enter_subaction(tick: Tick, subaction):
	_canceled = true
