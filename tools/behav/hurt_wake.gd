extends "res://tools/behav/ext_action.gd"

export (float) var invincible_frames = 10

const HurtState = AttackData.HurtState

func action(tick):
	var target = tick.target
	target.set_key_position()
	target.current_action = self
	target.hurt_data = null
	target.invincible_in(invincible_frames)
	tick.global_context.last_hurt_state = HurtState.Wake
	return Status.SUCCEED
