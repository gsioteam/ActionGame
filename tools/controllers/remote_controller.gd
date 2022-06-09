extends "res://tools/controllers/controller.gd"

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
const schemas = preload("res://scenes/remote_list/schemas.gd")
const ExtAction = preload("res://tools/behav/ext_action.gd")
const RemoteData = preload("res://tools/controllers/remote_data.gd")

var room: colyseus.Room
var char_schema: schemas.CharSchema
var behav_node: ExtAction
var last_path
var last_run_id
var finished = false

var last_shot_id = 0

var control: bool setget ,is_control

var _old_move_id = 0
var move_id = 0

var _owner

func _init(parent, room, char_schema).(parent.character, parent):
	_owner = char_schema.owner
	self.room = room
	self.char_schema = char_schema
	self.char_schema.listen(":replace").on(funcref(self, "_on_owner_replace"))

func is_control():
	return room.session_id == _owner

func tick():
	if is_control():
		.tick()
	else:
		character.hp = char_schema.hp
		if character.has_method("set_energy"):
			character.set_energy(char_schema.energy)
		
		if char_schema.position_frame != character.position_frame:
			character.transform.origin = Vector3(char_schema.x, char_schema.y, char_schema.z)
			character.position_frame = char_schema.position_frame
		
		var hurt_data = char_schema.hurt_data
		if hurt_data.hurt_id == 0:
			character.hurt_data = null
		else:
			if character.hurt_data == null or character.hurt_data.id != hurt_data.hurt_id:
				var data = AttackData.Information.new(
					hurt_data.power, 
					Vector3(hurt_data.direction_x, hurt_data.direction_y, hurt_data.direction_z), 
					hurt_data.damage, 
					hurt_data.attack_type)
				data.direction_type = hurt_data.direction_type
				data.gravity_scaling = hurt_data.gravity_scaling
				data.launch_damage = hurt_data.launch_damage
				data.id = hurt_data.hurt_id
				data.from = character.get_scene_node(hurt_data.from)
				character.set_hurt_data(data)
			
		var action = char_schema.action
		if behav_node != null:
			if last_path == action.path:
				if last_run_id != action.run_id and not behav_node.continuous:
					behav_node.reset()
					behav_node = null
			else:
				behav_node.reset()
				behav_node = null
		if behav_node == null:
			character.set_face(char_schema.face)
			character.state = char_schema.character_state
			if action.path.length() > 0 and action.run_id > 0:
				behav_node = character.get_node(action.path)
				behav_node.run_id = action.run_id
				var json = JSON.parse(action.data)
				if json.error == OK:
					behav_node.ext_data = json.result
				else:
					behav_node.ext_data = null
				last_run_id = action.run_id
				last_path = action.path
				finished = false
		if behav_node != null:
			tick.frame_context["remote"] = true
			var ret = behav_node.get_action_node().run_tick(tick)
			if ret != BNode.Status.RUNNING and not behav_node.continuous:
				finished = true
		else:
			# character.move_speed = Vector3.ZERO
			pass
		
		if char_schema.move_frame != character.move_frame:
			character.move_frame = char_schema.move_frame
			character.move_speed = Vector3(char_schema.move_x, char_schema.move_y, char_schema.move_z)
			
		if character.paused_frame_count <= 0:
			var anim = character.get_anim()
			if anim.playback_speed == 0:
				anim.playback_speed = 1
			var speed = character.move_speed
			if character.face != Defines.Face.Right:
				speed.x = -speed.x
			character.move_and_slide(speed)
		else:
			character.paused_frame_count -= 1

func update(delta):
	if not is_control():
		var pos = Vector3(char_schema.x, char_schema.y, char_schema.z)
		var local_pos = character.transform.origin
		var dis = pos.distance_to(local_pos)
		if dis > 1:
			character.transform.origin = pos
		#else:
		#	character.transform.origin = (pos - local_pos) * delta * 20 + local_pos
	pass

func is_vec_nan(vec3: Vector3):
	return is_nan(vec3.x) or is_nan(vec3.y) or is_nan(vec3.z)

func get_character_data():
	if room.session_id != char_schema.owner:
		return null
	
	var data = RemoteData.get_character_data(character)
	data["owner"] = _owner
	return data

func set_key_speed():
	move_id += 1

func swap_target(character):
	_owner = character.controller.get_owner()
	if _owner != room.session_id:
		print("Swap to ", _owner, " ", character.name)

func get_owner():
	return _owner

func _on_owner_replace(character, new_value, key):
	if key == "owner":
		_owner = new_value
		if _owner == room.session_id:
			print("Get control ", self.character.name)

func get_lag():
	var state = room.get_state()
	var player = state.players.at(char_schema.owner)
	if player:
		return player.lag
	return -1
	
