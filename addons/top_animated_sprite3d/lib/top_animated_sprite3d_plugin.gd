
extends EditorInspectorPlugin

const TopAnimationSprite3D = preload("res://addons/top_animated_sprite3d/lib/top_animated_sprite3d.gd")
const AnimationEditor = preload("animation_editor.gd")

func can_handle(object):
	return object is TopAnimationSprite3D


func parse_property(object, type, path, hint, hint_text, usage):
	if path == "animation":
		add_property_editor(path, AnimationEditor.new())
		return true
	elif path == "frame":
		
		return false
	else:
		return false
