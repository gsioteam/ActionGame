extends Spatial


export var step_dis = 0.2
export var min_distance = 0.02
var _max_len = 1
var _ray: RayCast

# Called when the node enters the scene tree for the first time.
func _ready():
	_ray = $ray
	var sprite = $sprite3d
	_max_len = sprite.frames.get_frame_count(sprite.animation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var sprite = $sprite3d
	var point = _ray.get_collision_point()
	if point != Vector3.ZERO:
		var distance_to_ground = (point - global_transform.origin).length()
		var step = floor(distance_to_ground / step_dis)
		step = int(max(0, min(_max_len - 1, step))) 
		sprite.frame = _max_len - step
		sprite.global_transform.origin = point
		sprite.visible = true
	else:
		sprite.visible = false
		
func is_on_ground(p = false):
	var point = _ray.get_collision_point()
	var distance_to_ground = (point - global_transform.origin).length()
	if p:
		print(distance_to_ground)
	return distance_to_ground < min_distance
