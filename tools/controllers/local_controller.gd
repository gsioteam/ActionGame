extends "res://tools/controllers/controller.gd"

func _init(character, parent = null).(character, parent):
	pass

func tick():
	var cmds = character.get_cmds()
	if cmds != null:
		cmds.tick()
	
	var node = character.get_behav()
	var speed = Vector3.ZERO
	if node != null:
		tick.frame_context["remote"] = false
		node.run_tick(tick)
		tick.end_frame()
		if character.paused_frame_count <= 0:
			var anim = character.get_anim()
			if anim.playback_speed == 0:
				anim.playback_speed = 1
			speed = character.move_speed
			if character.face != Defines.Face.Right:
				speed.x = -speed.x
			character.move_and_slide(speed)
		else:
			character.paused_frame_count -= 1
