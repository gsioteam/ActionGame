extends Reference


static func get_character_data(character):
	var scene = character.get_scene()
	var pos = character.transform.origin
	
	var action = {
		"path": '',
		"run_id": 0,
		"data": "null"
	}
	if character.current_action != null:
		var cur_action = character.current_action
		action["path"] = str(character.get_path_to(cur_action))
		action["run_id"] = cur_action.run_id
		action["data"] = JSON.print(cur_action.ext_data)
	
	var hurt_data = {
		"id": 0,
	}
	if character.hurt_data != null:
		hurt_data["power"] = character.hurt_data.power
		hurt_data["direction_x"] = character.hurt_data.direction.x
		hurt_data["direction_y"] = character.hurt_data.direction.y
		hurt_data["direction_z"] = character.hurt_data.direction.z
		hurt_data["damage"] = character.hurt_data.damage
		hurt_data["attack_type"] = character.hurt_data.attack_type
		hurt_data["direction_type"] = character.hurt_data.direction_type
		hurt_data["gravity_scaling"] = character.hurt_data.gravity_scaling
		hurt_data["launch_damage"] = character.hurt_data.launch_damage
		hurt_data["from"] = str(scene.get_path_to(character.hurt_data.from))
		hurt_data["id"] = character.hurt_data.id
	
	var data = {
		"x": pos.x,
		"y": pos.y,
		"z": pos.z,
		"position_frame": character.position_frame,
		"node": str(scene.get_path_to(character)),
		"action": action,
		"hurt_data": hurt_data,
		"hp": character.hp,
		"face": character.face,
		"move_x": character.move_vector.x,
		"move_y": character.move_vector.y,
		"move_z": character.move_vector.z,
		"move_frame": character.move_frame,
		"character_state": character.state,
	}
	if character.has_method("get_energy"):
		data["energy"] = character.get_energy()
	return data
