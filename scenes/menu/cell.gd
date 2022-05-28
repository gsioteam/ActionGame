extends HBoxContainer

tool

export (String) var title = "Title" setget set_title, get_title
export (String) var button_text = "Edit" setget set_button_text, get_button_text

signal button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_button_pressed():
	emit_signal("button_pressed", self)

func set_title(v):
	$label.text = v

func get_title():
	return $label.text

func set_button_text(v):
	$button.text = v

func get_button_text():
	return $button.text
