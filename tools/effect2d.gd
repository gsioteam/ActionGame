extends "res://tools/effect.gd"


func _set_face(face):
	if face == origin_face:
		$sprite.flip_h = false
	else:
		$sprite.flip_h = true
