extends VBoxContainer


var _selected = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_child(_selected).grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		var child
		while true:
			_selected = (_selected + 1) % get_child_count()
			child = get_child(_selected)
			if child.visible:
				break
		child.grab_focus()
	elif Input.is_action_just_pressed("ui_up"):
		var child
		while true:
			_selected -= 1
			if _selected < 0:
				_selected += get_child_count()
			child = get_child(_selected)
			if child.visible:
				break
		child.grab_focus()
	elif Input.is_action_just_pressed("ui_accept"):
		var child = get_child(_selected)
		child.emit_signal("pressed")
