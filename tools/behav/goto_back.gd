extends "res://tools/behav/path_walk.gd"


export (float) var distance = 5
export (float) var speed = 0.2
export (int) var max_frame = 120

func action(tick: Tick):
	if tick.frame_context.remote:
		load_data(tick)
	else:
		var this: Character = tick.target
		var target: Character = tick.global_context.target
		var this_pos = this.global_transform.origin
		var target_pos = target.global_transform.origin
		
		var dis = distance + rand_range(-0.5, 0.5)
		var angle
		if target.face == Defines.Face.Left:
			angle = 0
		else:
			angle = PI
		
		angle += rand_range(- PI / 6, PI / 6)
		
		var from = this_pos
		from.y = 0
		var to = target_pos + Vector3(cos(angle), 0, sin(angle)).normalized() * dis
		to.y = 0
		
		var oneway = (to.x - target_pos.x) * (this_pos.x - target_pos.x)
		if oneway > 0:
			path = create_path([from, to], speed)
		else:
			var neg = 1
			if randf() > 0.5:
				neg = -1
			var middle = target_pos + Vector3(0, 0, dis * neg)
			middle.y = 0
			
			path = create_path([from, middle, to], speed)
			
		save_data(tick)
		print(target_pos, ext_data)
	
	return .action(tick)


