extends EditorProperty

var menu_button: MenuButton
const TopAnimationSprite3D = preload("res://addons/top_animated_sprite3d/lib/top_animated_sprite3d.gd")

func _init():
	menu_button = MenuButton.new()
	add_child(menu_button)
	add_focusable(menu_button)
	menu_button.connect("about_to_show", self, "_show_menu")
	menu_button.get_popup().connect("index_pressed", self, "_item_select")

func _has(array: PoolStringArray, string: String):
	for s in array:
		if s == string:
			return true
	return false

func update_property():
	var target:TopAnimationSprite3D  = get_edited_object()
	var new_value = target[get_edited_property()]
	
	if target.frames == null:
		menu_button.text = "default"
		return
	var names = target.frames.get_animation_names()
	
	if (_has(names, new_value)):
		menu_button.text = new_value
	else:
		if names.size() > 0:
			emit_changed(get_edited_property(), names[0])
		else:
			emit_changed(get_edited_property(), "default")
	
func _show_menu():
	var target:TopAnimationSprite3D  = get_edited_object()
	if target.frames == null:
		var menu = menu_button.get_popup()
		menu.clear() 
		menu.add_check_item("default")
		menu.set_item_checked(0, true)
	else:
		var menu = menu_button.get_popup()
		menu.clear() 
		
		var names = target.frames.get_animation_names()
		for idx in range(0, names.size()):
			var name = names[idx]
			menu.add_check_item(name)
			if name == target.animation:
				menu.set_item_checked(idx, true)

func _item_select(idx: int):
	var target:TopAnimationSprite3D  = get_edited_object()
	var names = target.frames.get_animation_names()
	if names.size() > idx:
		var name = names[idx]
		if name != target.animation:
			emit_changed(get_edited_property(), name)
