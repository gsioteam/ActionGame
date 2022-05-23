extends Node2D

export var move_speed: Vector3 setget set_move_speed, get_move_speed
var on_move_speed: FuncRef
var _move_speed: Vector3 = Vector3.ZERO

func _ready():
	pass # Replace with function body.

func get_anim():
	return $anim

func get_sprite():
	return $sprite

func set_move_speed(v: Vector3):
	_move_speed = v
	on_move_speed.call_func(v)
	
func get_move_speed() -> Vector3:
	return _move_speed
