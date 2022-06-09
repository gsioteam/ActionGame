extends Node

signal physics_process

func _physics_process(delta):
	emit_signal("physics_process", delta)
