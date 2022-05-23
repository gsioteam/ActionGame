extends "res://addons/action_behavior_tree/lib/if.gd"

export (String) var box_name

var box: Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func test(tick):
	if box == null:
		var target: Character = tick.target
		box = target.get_boxes().get_node(box_name)
	if box != null:
		for area in box.get_overlapping_areas():
			if area.character == tick.global_context.target:
				return true
	return false
