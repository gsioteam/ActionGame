extends "res://tools/char.gd"

class_name Character2D

tool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _face(face):
	var x = 1
	if face != _origin_face:
		x = -1
	$container.scale = Vector3(x, 1, 1)
	$boxes.scale = Vector3(x, 1, 1)

