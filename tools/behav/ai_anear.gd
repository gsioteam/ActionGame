extends "res://tools/behav/path_walk.gd"

export (float) var speed = 1
export (float) var max_frame = 120
export (float) var far = 2
export (float) var near = 0.1

func action(tick):
	if tick.frame_context.remote:
		load_data(tick)
	else:
		var this: Character = tick.target
		var target: Character = tick.global_context.target
		var this_pos = this.global_transform.origin
		var target_pos = target.global_transform.origin
		
		var neg = 1
		if this_pos.x < target_pos.x:
			neg = -1
		var pos1
		var pos2
		if abs(this_pos.x - target_pos.x) > far:
			pos1 = target_pos + Vector3(neg * far, 0, 0)
		else:
			pos1 = target_pos
			pos1.x = this_pos.x
		pos2 = target_pos + Vector3(neg * near, 0, 0)
		
		var from = this_pos
		from.y = 0
		pos1.y = 0
		pos2.y = 0
		
		path = create_path([from, pos1, pos2], speed)
		
		save_data(tick)
	return .action(tick)

func can_cancel(tick: Tick, frame: int):
	return true
