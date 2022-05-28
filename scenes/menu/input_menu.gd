tool
extends Control

var config

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_cancel_pressed():
	var ret = ResourceSaver.save(Defines.ConfigPath, config)
	var scene_pack = load("res://ui/main_menu/main_menu.tscn")
	var scene = scene_pack.instance()
	get_parent().add_child(scene)
	queue_free()
