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

enum OnlineState {
	Offline,
	Online
}

const RoomName = "game_room"
const GrabbedCounter = "grabbed_counter"
const InvincibleCounter = "invincible_counter"
const ConfigPath = "user://config.tres"

static func instance(path: String):
	if Engine.has_meta(path):
		return Engine.get_meta(path)
	else:
		var ins = load(path)
		if ins is Script:
			ins = ins.new()
		Engine.set_meta(path, ins)
		return ins

const default_config = preload("res://configs/configs.tres")

static func load_config():
	var config
	if ResourceLoader.exists(ConfigPath):
		config = ResourceLoader.load(ConfigPath)
	else:
		config = default_config
	return config
