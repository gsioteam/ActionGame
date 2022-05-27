extends Control

var text: String setget set_text, get_text
export (float) var times = 1

var _counter = 0
var _begin

func set_text(v):
	$label.text = v

func get_text():
	return $label.text

func _process(delta):
	if _begin == null:
		_begin = get_transform().origin
		print(_begin)
	_counter += delta
	if _counter > times:
		get_parent().remove_child(self)
	else:
		modulate = Color(1, 1, 1, 1 - max(0, _counter / times * 2 - 1))
		set_position(_begin + Vector2(0, _counter / times * -10))

func reset(position):
	_counter = 0
	_begin = position
	set_position(position)
