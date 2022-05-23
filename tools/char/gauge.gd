
tool
extends NinePatchRect

export (float, 0, 1) var percent = 1 setget set_percent, get_percent
export (Color) var bar_color = Color.yellow setget set_bar_color, get_bar_color
export (Color) var bg_color = Color.red setget set_bg_color, get_bg_color

func _ready():
	var size = rect_size
	self.bg.rect_size = size
	self.bar.rect_size = Vector2(size.x * self.percent - 4, size.y - 4)
	self.bg.modulate = _bg_color
	self.bar.modulate = _bar_color

func _on_resized():
	var size = rect_size
	self.bg.rect_size = size
	self.bar.rect_size = Vector2(size.x * self.percent - 4, size.y - 4)

var _bar: TextureRect
var bar: TextureRect setget , get_bar
func get_bar():
	if _bar == null:
		_bar = $bar
	return _bar

var _bg: TextureRect
var bg: TextureRect setget , get_bg
func get_bg():
	if _bg == null:
		_bg = $bg
	return _bg

var _percent
func set_percent(v):
	if _percent != v:
		_percent = v
		var size = rect_size
		if _bar != null:
			_bar.rect_size = Vector2(size.x * _percent - 4, size.y - 4)

func get_percent():
	return _percent

var _bar_color = Color.yellow
func set_bar_color(v):
	if _bar_color != v:
		_bar_color = v
		if _bar != null:
			_bar.modulate = v

func get_bar_color():
	return _bar_color

var _bg_color = Color.red
func set_bg_color(v):
	if _bg_color != v:
		_bg_color = v
		if _bg != null:
			_bg.modulate = v

func get_bg_color():
	return _bg_color
