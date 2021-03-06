extends "res://tools/char.gd"

class_name Character2D

tool

export (float) var rot = 0

func _face(face):
	var x = 1
	if face != _origin_face:
		x = -1
	$container.scale = Vector3(x, 1, 1)
	$boxes.scale = Vector3(x, 1, 1)

func _enter_tree():
	var game_scene = GameScene.current(self)
	$container/sprite.rotation_degrees = Vector3(game_scene.rot, 0, 0)

