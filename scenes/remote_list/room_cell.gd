extends HBoxContainer

var text setget set_text, get_text
var data

signal button_click

func set_text(v):
	$name.text = v
	
func get_text():
	return $name.text



func _on_enter_pressed():
	emit_signal("button_click", self)
