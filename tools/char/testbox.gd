extends Area

tool
const Char = preload("res://tools/char.gd")

var character
export(bool) var draw = false
export(Color) var draw_color = Color(0, 0.2, 1, 0.6)

var _material: SpatialMaterial

func _ready():
	var parent = get_parent()
	while parent != null:
		if parent is Char:
			character = parent
			break
		parent = parent.get_parent()
	if draw or Engine.editor_hint:
		$draw.visible = draw
		_material = $draw.material_override.duplicate()
		_material.albedo_color = draw_color
		$draw.material_override = _material

func _process(delta):
	if Engine.editor_hint:
		if $draw.visible != draw:
			$draw.visible = draw
		_material.albedo_color = draw_color
