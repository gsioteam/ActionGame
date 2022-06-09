extends "res://tools/behav/path_walk.gd"

export (float) var distance = 2
export (float) var speed = 0.2

func action(tick: Tick):
	if tick.frame_context.remote:
		load_data(tick)
	else:
		var target: Character = tick.global_context.target
		var this: Character = tick.target
		var target_pos = target.position_2d
		var this_pos = this.position_2d
		
		var dis = distance + rand_range(-0.5, 0.5)
		var angle = PI / 2
		var vec = target_pos - this_pos
		if vec.length() > 0.1:
			angle = atan2(vec.y, vec.x)
		angle += rand_range(-PI / 6, PI / 6)
		
		var from = this.transform.origin
		from.y = 0
		vec = -Vector3(cos(angle), 0, sin(angle)).normalized()
		var to = Vector3(target_pos.x, 0, target_pos.y) + vec * dis
		path = create_path([from, to], speed) 
		
		save_data(tick)
		
	return .action(tick)
	
