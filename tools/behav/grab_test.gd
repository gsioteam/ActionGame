extends "res://addons/action_behavior_tree/lib/if.gd"

const HurtBox = preload("res://tools/char/hurtbox.gd")

export (String) var check_box = "grab"
var _check_box: Area

func test(tick: Tick):
	var target: Character = tick.target
	
	if _check_box == null:
		_check_box = target.get_boxes().find_node(check_box)
	var boxes = _check_box.get_overlapping_areas()
	for box in boxes:
		if box is HurtBox and box.is_visible_in_tree():
			var character: Character = box.character
			if character.state == Defines.CharacterState.Stand and character.get_counter(Defines.GrabbedCounter) == 0:
				tick.global_context.grab_target = character
				return true
	return false;
