extends MeshInstance

tool 

export var frames: SpriteFrames setget _set_frames, _get_frames
export var animation: String setget _set_animation, _get_animation
export var frame: int setget _set_frame, _get_frame
export(float, 0.0001, 128) var pixel_size: float = 0.01 setget _set_pixel_size, _get_pixel_size
export var flip_h: bool setget set_flip_h, get_flip_h
export var flip_v: bool setget set_flip_v, get_flip_v

var _frames: SpriteFrames
var _animation = "default"
var _frame = 0
var _pixel_size: float = 0.01
var _flip_h: bool = false
var _flip_v: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if mesh == null:
		mesh = QuadMesh.new()
		mesh.size = Vector2(0.24, 0.24)
	if material_override == null:
		var material: Material = preload("material.tres")
		material_override = material.duplicate()

func _set_frames(v):
	if _frames != v:
		if _frames != null:
			_frames.disconnect("changed", self, "_update")
		_frames = v
		_frames.connect("changed", self, "_update")
		_update()

func _get_frames():
	return _frames

func _set_animation(v):
	if _animation != v:
		_animation = v
		if _frame >= _frames.get_frame_count(_animation):
			_frame = 0
		_update()

func _get_animation():
	return _animation

func _set_frame(idx):
	if _frames == null || idx >= _frames.get_frame_count(_animation) || idx < 0:
		return
	if _frame != idx:
		_frame = idx
		_update()

func _get_frame():
	return _frame

func _update():
	if _frames == null || _frames.get_frame_count(_animation) <= _frame:
		return
	var texture: AtlasTexture = _frames.get_frame(_animation, _frame)
	var region = texture.region
	var max_size = texture.atlas.get_size()
	material_override.set_texture(SpatialMaterial.TEXTURE_ALBEDO, texture)
	var uv = Vector3(region.size.x / max_size.x, region.size.y / max_size.y, 1)
	var offset = Vector3(region.position.x / max_size.x, region.position.y / max_size.y, 0)
	if _flip_h:
		offset.x = offset.x + uv.x
		uv.x = -uv.x
	if _flip_v:
		offset.y = offset.y + uv.y
		uv.y = -uv.y
	material_override.uv1_scale = uv
	material_override.uv1_offset = offset
	mesh.size = Vector2(region.size.x * _pixel_size, region.size.y * _pixel_size)

func  _set_pixel_size(v):
	if _pixel_size != v:
		_pixel_size = v;
		_update()

func _get_pixel_size():
	return _pixel_size

func set_flip_h(v):
	if _flip_h != v:
		_flip_h = v
		_update()

func get_flip_h():
	return _flip_h

func set_flip_v(v):
	if _flip_v != v:
		_flip_v = v
		_update()

func get_flip_v():
	return _flip_v
