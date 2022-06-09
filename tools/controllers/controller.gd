extends Reference

var tick: BNode.Tick
var character: KinematicBody
var current_action
var parent

func _init(character, parent = null):
	self.character = character
	self.parent = parent
	if parent == null:
		tick = BNode.Tick.new(character)
	else:
		tick = parent.tick

func tick():
	if parent:
		parent.tick()

func update(delta):
	pass

func next_action_phase():
	if current_action != null:
		current_action.next_phase(tick)

func get_character_data():
	return null

func set_key_speed():
	pass

func swap_target(character):
	pass

func get_owner():
	return ""

func get_lag():
	return 0
