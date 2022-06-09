extends "res://tools/behav/ext_action.gd"

export (String) var idle_anim = "idle"
export (String) var boring_anim = "boring"
export (int) var boring_frames = 60

var idle_frames = 0
var _idle_reset = false

func action(tick: Tick):
	var target: Character = tick.target
	target.current_action = self
	if idle_frames < boring_frames:
		target.animate(idle_anim)
	else:
		target.animate(boring_anim)

func reset():
	.reset()
	_idle_reset = true

func _physics_process(delta):
	if has_new():
		idle_frames += 1
	else:
		idle_frames = 0
