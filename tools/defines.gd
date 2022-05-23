extends Object

class_name Defines

enum Face {
	None,
	Left,
	Right
}

enum CharaterType {
	Ally,
	Enemy,
}

enum CharacterState {
	Stand,
	Air,
	Pain,
	Launched,
	Down,
	Grabbed
}

const GrabbedCounter = "grabbed_counter"
const InvincibleCounter = "invincible_counter"

static func instance(path: String):
	if Engine.has_meta(path):
		return Engine.get_meta(path)
	else:
		var ins = load(path)
		if ins is Script:
			ins = ins.new()
		Engine.set_meta(path, ins)
		return ins
