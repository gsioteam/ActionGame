tool
extends EditorPlugin

var plugin


func _enter_tree():
	plugin = preload("res://addons/top_animated_sprite3d/lib/top_animated_sprite3d_plugin.gd").new()
	add_inspector_plugin(plugin)
	add_custom_type(
		"TopAnimatedSprite3D",
		"MeshInstance",
		preload("res://addons/top_animated_sprite3d/lib/top_animated_sprite3d.gd"),
		preload("res://addons/top_animated_sprite3d/lib/top_animated_sprite3d.png")
	)

func _exit_tree():
	remove_inspector_plugin(plugin)
	remove_custom_type("TopAnimatedSprite3D")
