extends "res://addons/action_behavior_tree/lib/if.gd"

const HurtState = AttackData.HurtState

var _switch

func _ready():
	_switch = $switch

func test(tick):
	var target: Character = tick.target
	if target.hp <= 0:
		_switch.index = 1
		return true
	var has_hurt_data = target.get_hurt_data()
	if has_hurt_data != null:
		if not tick.global_context.has("last_hurt_state"):
			tick.global_context.last_hurt_state = HurtState.Wake
		tick.global_context.erase("target")
		var last_state = tick.global_context.last_hurt_state
		if last_state != HurtState.Launched:
			if has_hurt_data.attack_type != AttackData.AttackType.Hit or target.air_test():
				if has_hurt_data.attack_type == AttackData.AttackType.Launch:
					last_state = HurtState.Launched
				elif has_hurt_data.attack_type == AttackData.AttackType.Smash:
					last_state = HurtState.Smashed
				elif has_hurt_data.attack_type == AttackData.AttackType.Grab:
					last_state = HurtState.Grabbed
				else:
					last_state = HurtState.Launched
			else:
				last_state = HurtState.Stun
			tick.global_context.last_hurt_state = last_state
		var switch = _switch
		if last_state == HurtState.Wake:
			return false
		
		match last_state:
			HurtState.Smashed:
				switch.index = 0
			HurtState.Launched:
				switch.index = 1
			HurtState.Grabbed:
				switch.index = 2
			HurtState.Stun:
				switch.index = 3
			HurtState.Down:
				switch.index = 4
			HurtState.Wake:
				assert(true)
	return has_hurt_data != null
