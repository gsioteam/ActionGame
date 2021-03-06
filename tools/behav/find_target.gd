extends "res://addons/action_behavior_tree/lib/action.gd"

var _old_target

func action(tick):
	if not tick.global_context.has("target"):
		var target = _find(tick)
		if target != null:
			tick.global_context["target"] = target
		if _old_target != target:
			_old_target = target
			tick.target.swap_target(target)
			tick.target.animate("idle")
			return Status.SUCCEED
	return Status.FAILED

func _find(tick: Tick):
	var scene = GameScene.current(self)
	if scene != null:
		var this: Character = tick.target
		var this_pos: Vector3 = tick.target.global_transform.origin
		this_pos.y = 0
		var target
		var min_dis = 999
		for item in scene.allies:
			var ally: Character = item
			var ally_pos = ally.global_transform.origin
			ally_pos.y = 0
			var dis = this_pos.distance_to(ally_pos)
			if ally.hp > 0 and dis < min_dis:
				min_dis = dis
				target = ally
		return target
