extends Node

enum Status {
	Normal,
	Special
}

export(Status) var value: int


# Called when the node enters the scene tree for the first time.
func _ready():
	var menu_button = $Control/MenuButton
	menu_button.get_popup().add_check_item("test1")
	menu_button.get_popup().add_item("test2")
	menu_button.get_popup().add_item("test3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
