extends "res://tools/behav/ext_action.gd"

const FRAMES_PER_SECOUND = 60

class PathNode:
	var pos: Vector3
	var frames: int
	var speed: Vector3
	
	func _init(pos, frames):
		self.pos = pos
		self.frames = frames
	
	func _calculate(from: Vector3):
		# TODO: The fixed 60 fps
		speed = (pos - from) / frames * FRAMES_PER_SECOUND

var path: Array = []
var _frame = 0
var _offset = 0

signal completed

func action(tick: Tick):
	if path.empty():
		return Status.FAILED
	else:
		_frame = 0
		_offset = 0
		var target: Character = tick.target
		target.current_action = self
		
		var local_pos = target.transform.origin
		var arr = []
		for node in path:
			node._calculate(local_pos)
			local_pos = node.pos
		target.animate("walk")

		yield(self, "completed")
		
		return Status.SUCCEED

func running(tick: Tick, frame: int):
	if _offset < path.size():
		var node = path[_offset]
		var this: Character = tick.target
		
		var target: Character = tick.global_context.target
		var target_pos = target.position_2d
		var this_pos = this.position_2d
		
		if abs(target_pos.x - this_pos.x) > 0.3:
			var face
			if target_pos.x > this_pos.x:
				face = Defines.Face.Right
			else:
				face = Defines.Face.Left
			this.set_face(face)
		
		this.set_move_speed(node.speed, true)
		if name == "att1_anear":
			print(node.speed)
		
		_frame += 1
		if _frame >= node.frames:
			_frame = 0
			_offset += 1
			
			if _offset >= path.size():
				emit_signal("completed")

func new_path_node(from: Vector3, to: Vector3, speed: float):
	var dis = (to - from).length()
	return PathNode.new(to, ceil(dis / speed * FRAMES_PER_SECOUND))

func load_data(tick):
	tick.global_context["target"] = GameScene.my_node(tick.target, ext_data.target)
	path.clear()
	for data in ext_data.path:
		path.append(PathNode.new(
			Vector3(data.x, data.y, data.z),
			data.frames
		))

func save_data(tick):
	var list = []
	for node in path:
		list.append({
			"x": node.pos.x,
			"y": node.pos.y,
			"z": node.pos.z,
			"frames": node.frames,
		})
	ext_data = {
		"target": GameScene.my_path(tick.target),
		"path": list,
	}

func create_path(points: Array, speed: float):
	var path = []
	var p = points[0]
	for idx in range(points.size() - 1):
		var next = points[idx + 1]
		var node = new_path_node(p, next, speed)
		p = next
		if node.frames == 0:
			continue
		path.append(node)
	return path
