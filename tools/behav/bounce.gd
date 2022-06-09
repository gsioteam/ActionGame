extends "res://tools/behav/ext_action.gd"

signal finished

func action(tick):
	var target: Character = tick.target
	target.current_action = self
	target.animate('launched', true)
	target.move_speed.y = 2
	yield(self, "finished")
	get_node("../down").require_focus()
	
func running(tick: Tick, frame: int):
	var target: Character = tick.target
	var speed = target.move_speed
	if speed.y < 0 and not target.air_test():
		emit_signal("finished")
		return
	speed.y -= target.gravity * 0.8
	target.move_speed = speed
	
