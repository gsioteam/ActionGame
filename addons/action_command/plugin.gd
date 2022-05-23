tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"CommandManager",
		"Node",
		preload("res://addons/action_command/lib/command_manager.gd"),
		preload("res://addons/action_command/lib/command_manager.png")
	)


func _exit_tree():
	remove_custom_type("CommandManager")
