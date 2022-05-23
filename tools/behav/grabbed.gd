extends "res://addons/action_behavior_tree/lib/action.gd"


const _anims = ["grabbed", "hurt"]

signal finished

var anim_name
var _position_sync = false

var target
var character

func action(tick):
	var target: Character = tick.target
	var hurt_data = target.get_hurt_data()
	self.target = hurt_data.relative_point
	character = target
	if anim_name == null:
		if target.get_anim().has_animation("grabbed"):
			anim_name = "grabbed"
		else:
			anim_name = "hurt"
	target.animate(anim_name)
	_position_sync = true
	yield(self, "finished")
	target.set_counter(Defines.GrabbedCounter, 60)
	get_node("../wake").require_focus()

func running(tick: Tick, frame: int):
	var target: Character = tick.target
	target.state = Defines.CharacterState.Grabbed
	var hurt_data = target.get_hurt_data()
	var from: Character = hurt_data.from
	var checked = from.current_action != null and from.current_action.has_method("grab_data") and hurt_data == from.current_action.grab_data()
	if not checked:
		emit_signal("finished")
	else:
		pass

func stop_running():
	_position_sync = false
	
func _process(delta):
	if _position_sync:
		var pos = target.global_transform.origin
		var grabbed_pos = character.get_grabbed_point().global_transform.origin
		var char_pos = character.global_transform.origin
		character.global_transform.origin = char_pos - grabbed_pos + pos
