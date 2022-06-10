
extends Object

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")

class HurtDataSchema extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("hurt_id", colyseus.NUMBER),
			colyseus.Field.new("power", colyseus.NUMBER),
			colyseus.Field.new("direction_x", colyseus.NUMBER),
			colyseus.Field.new("direction_y", colyseus.NUMBER),
			colyseus.Field.new("direction_z", colyseus.NUMBER),
			colyseus.Field.new("damage", colyseus.NUMBER),
			colyseus.Field.new("attack_type", colyseus.NUMBER),
			colyseus.Field.new("direction_type", colyseus.NUMBER),
			colyseus.Field.new("gravity_scaling", colyseus.NUMBER),
			colyseus.Field.new("launch_damage", colyseus.NUMBER),
			colyseus.Field.new("from", colyseus.STRING),
		]

class ActionSchema extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("path", colyseus.STRING),
			colyseus.Field.new("run_id", colyseus.NUMBER),
			colyseus.Field.new("data", colyseus.STRING),
		]

class CharSchema extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("x", colyseus.NUMBER),
			colyseus.Field.new("y", colyseus.NUMBER),
			colyseus.Field.new("z", colyseus.NUMBER),
			colyseus.Field.new("position_frame", colyseus.NUMBER),
			colyseus.Field.new("action", colyseus.REF, ActionSchema),
			colyseus.Field.new("hurt_data", colyseus.REF, HurtDataSchema),
			colyseus.Field.new("state", colyseus.NUMBER),
			colyseus.Field.new("owner", colyseus.STRING),
			colyseus.Field.new("face", colyseus.NUMBER),
			colyseus.Field.new("hp", colyseus.NUMBER),
			colyseus.Field.new("energy", colyseus.NUMBER),
			colyseus.Field.new("move_x", colyseus.NUMBER),
			colyseus.Field.new("move_y", colyseus.NUMBER),
			colyseus.Field.new("move_z", colyseus.NUMBER),
			colyseus.Field.new("move_frame", colyseus.NUMBER),
			colyseus.Field.new("character_state", colyseus.NUMBER),
		]
	
	func get_position():
		return Vector3(self.x, self.y, self.z)

class PlayerSchema extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("name", colyseus.STRING),
			colyseus.Field.new("state", colyseus.NUMBER),
			colyseus.Field.new("lag", colyseus.NUMBER),
		]

class RoomState extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("characters", colyseus.MAP, CharSchema),
			colyseus.Field.new("players", colyseus.MAP, PlayerSchema),
			colyseus.Field.new("name", colyseus.STRING),
			colyseus.Field.new("state", colyseus.NUMBER),
		]
