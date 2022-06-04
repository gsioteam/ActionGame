
extends Object

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")

class CharSchema extends colyseus.Schema:
	
	static func define_fields():
		return [
			colyseus.Field.new("x", colyseus.NUMBER),
			colyseus.Field.new("y", colyseus.NUMBER),
			colyseus.Field.new("z", colyseus.NUMBER),
			colyseus.Field.new("action", colyseus.STRING),
			colyseus.Field.new("state", colyseus.NUMBER),
			colyseus.Field.new("owner", colyseus.STRING),
		]

class PlayerSchema extends colyseus.Schema:
	static func define_fields():
		return [
			colyseus.Field.new("name", colyseus.STRING),
			colyseus.Field.new("state", colyseus.NUMBER),
		]

class RoomState extends colyseus.Schema:
	
	static func define_fields():
		return [
			colyseus.Field.new("characters", colyseus.MAP, CharSchema),
			colyseus.Field.new("players", colyseus.MAP, PlayerSchema),
			colyseus.Field.new("name", colyseus.STRING),
			colyseus.Field.new("state", colyseus.NUMBER),
		]
