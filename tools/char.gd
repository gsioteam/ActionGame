extends KinematicBody

class_name Character
const Defines = preload("res://tools/defines.gd")
const CommandManager = preload("res://addons/action_command/lib/command_manager.gd")
const Shadow = preload("res://tools/objects/shadow.gd")

const Face = Defines.Face
var tick: BNode.Tick
export(Face) var face = Face.Left
export(Vector3) var move_speed = Vector3.ZERO
export(float) var fall_speed = 0
export(float) var gravity_scale = 1
export(Defines.CharaterType) var type

export var xy_speed: Vector2 setget _set_xy_speed, _get_xy_speed
export var v_speed: float setget set_v_speed, get_v_speed

export(int) var max_hp = 100

var _hp: float = max_hp

var gravity setget , get_gravity

var paused_frame_count = 0
var paused: bool setget , is_paused

const Action = preload("res://tools/behav/action.gd")
var HurtBox

var current_action: Action

var guard_action

var hurt_data: AttackData.Information

var _origin_face

var _behav: BNode
var _anim: AnimationPlayer
var _boxes: Spatial
var _hurtbox
var _cmds: CommandManager
var _shadow: Shadow
var _grabbed_point: Position3D

var _state = Defines.CharacterState.Stand

var state: int setget set_state, get_state

var counters: Dictionary = {}

var _hurt_list = []
var _hurt_count = 0
var _gravity_scaling = 1
var _damage_scaling = 1

signal state_changed
signal damage
signal dead
signal hp_changed

export (PackedScene) var hits_label_pack = preload("res://effects/hits_label/hits_label.tscn")
var _hits_label

func get_hits_label():
	if _hits_label == null:
		_hits_label = hits_label_pack.instance()
	return _hits_label

var _dead = false

func _init():
	HurtBox = load("res://tools/char/hurtbox.gd")

func _ready():
	assert(face != Face.None)
	tick = BNode.Tick.new(self)
	_origin_face = face
	
func free():
	if _hits_label != null:
		_hits_label.queue_free()

func get_behav() -> BNode:
	if _behav == null:
		_behav = $behav
	return _behav

func get_anim() -> AnimationPlayer:
	if _anim == null:
		_anim = $anim
	return _anim

func get_boxes() -> Spatial:
	if _boxes == null:
		_boxes = $boxes
	return _boxes

var _is_cmds_init = false
func get_cmds() -> CommandManager:
	if not _is_cmds_init:
		_cmds = $cmds
		_is_cmds_init = true
	return _cmds

func get_shadow() -> Shadow:
	if _shadow == null:
		_shadow = $shadow
	return _shadow

func get_grabbed_point() -> Position3D:
	if _grabbed_point == null:
		_grabbed_point = $boxes/grabbed_point
	return _grabbed_point

func _physics_process(delta):
	if not visible or _dead:
		return
	if Engine.editor_hint:
		return
	var node = get_behav()
	if node != null:
		node.run_tick(tick)
		tick.end_frame()
		if paused_frame_count <= 0:
			if get_anim().playback_speed == 0:
				get_anim().playback_speed = 1
			var speed = move_speed
			if face != Face.Right:
				speed.x = -speed.x
			move_and_slide(speed)
		else:
			paused_frame_count -= 1
	var cmds = get_cmds()
	if cmds != null:
		cmds.tick()
	
	for key in counters.keys():
		var value = counters[key]
		if value > 0:
			 value -= 1
		counters[key] = value

func set_move_speed(speed: Vector3, ignore_face = false):
	if move_speed == speed:
		return
	if ignore_face:
		if face != Face.Right:
			speed.x = -speed.x
	move_speed = speed

func animate(name: String, reset = false):
	var anim = get_anim()
	if anim == null:
		return
	if anim.current_animation == name and not reset:
		return
	if anim.current_animation == name:
		anim.stop(true)
	anim.play(name)
	yield(anim, "animation_finished")

func queue_animate(animations: Array):
	var anim = get_anim()
	if anim == null:
		return
	for anim_name in animations:
		if anim.current_animation == anim_name:
			anim.stop(true)
		anim.play(anim_name)
		yield(anim, "animation_finished")

func set_face(value):
	if face != value:
		face = value
		_face(face)

func set_actions(actions: Array):
	get_cmds().actions = actions

func is_paused():
	return paused_frame_count > 0

func _face(face):
	pass

var invincible setget , get_invincible

func get_invincible():
	if counters.has(Defines.InvincibleCounter):
		return counters[Defines.InvincibleCounter] > 0
	return false

var _boxes_cache = {}
func get_box(path) -> Area:
	if not _boxes_cache.has(path):
		_boxes_cache[path] = get_boxes().get_node(path)
	return _boxes_cache[path]

var _reset_attack_status = false
func reset_attack_status():
	_reset_attack_status = true

func attack(hitboxes: PoolStringArray, excludes: Array, attack_info: AttackData.Information, spark_scene = null) -> bool:
	var hit = false
	if _reset_attack_status:
		excludes.clear()
		_reset_attack_status = false
		attack_info.repeat = true
	for box_name in hitboxes:
		var hitbox: Area = get_box(box_name)
		if hitbox == null or not hitbox.visible:
			continue
		for box in hitbox.get_overlapping_areas():
			if box is HurtBox and box.is_visible_in_tree():
				var character = box.character
				if not excludes.has(character) and attack_info.target_state_mask & (1 << character.state) > 0 && not character.invincible:
					hit = true
					excludes.append(character)
					on_hit(attack_info, character)
					character.attack_from(self, attack_info)
					var scene: Spatial
					var vec
					if spark_scene is FuncRef:
						scene = spark_scene.call_func(hitbox, box, character)
					elif spark_scene is PackedScene:
						scene = spark_scene.instance()
						vec = (hitbox.global_transform.origin + box.global_transform.origin) / 2 + Vector3(0,0,0.1)
					elif spark_scene is Spatial:
						scene = spark_scene
						vec = (hitbox.global_transform.origin + box.global_transform.origin) / 2 + Vector3(0,0,0.1)
					if scene != null:
						scene.set_face(face)
						get_parent().add_child(scene)
						if vec != null:
							scene.global_translate(vec)
	return hit

func attack_from(from, attack_info: AttackData.Information):
	if state == Defines.CharacterState.Stand and guard_action != null:
		guard_action.attack_from(self, from, attack_info)
		return
	hurt_data = attack_info
	hurt_data.from = from
	var exist = _hurt_list.has(attack_info.resource)
	if attack_info.attack_type != AttackData.AttackType.Grab:
		_hurt_list.append(attack_info.resource)
		var dmg = attack_info.damage * _damage_scaling
		_hp -= dmg
		emit_signal("damage", dmg)
		if from.type == Defines.CharaterType.Ally:
			var hits_label = get_hits_label()
			hits_label.text = str(_hurt_list.size(), " hits")
			var scene = GameScene.current(self)
			scene.interface.add_child(hits_label)
			var pos = scene.camera.camera.unproject_position(get_grabbed_point().global_transform.origin + Vector3(0, 0.1, 0))
			hits_label.reset(pos)
	if not attack_info.repeat and attack_info.attack_type != AttackData.AttackType.Grab:
		if exist:
			_gravity_scaling *= max(0.05, attack_info.gravity_scaling * 2 - 1) 
			_damage_scaling *= max(0.05, attack_info.damage_scaling * 2 - 1)
		else:
			_gravity_scaling *= attack_info.gravity_scaling
			_damage_scaling *= attack_info.damage_scaling
	match attack_info.direction_type:
		AttackData.DirectionType.Repulsion:
			if global_transform.origin.x < from.global_transform.origin.x:
				hurt_data.face = Defines.Face.Right
			else:
				hurt_data.face = Defines.Face.Left
		AttackData.DirectionType.Attracts:
			if global_transform.origin.x < from.global_transform.origin.x:
				hurt_data.face = Defines.Face.Left
			else:
				hurt_data.face = Defines.Face.Right
		_:
			match from.face:
				Defines.Face.Left:
					hurt_data.face = Defines.Face.Right
				Defines.Face.Right:
					hurt_data.face = Defines.Face.Left
				_:
					hurt_data.face = Defines.Face.None
				
	set_face(hurt_data.face)
	get_behav().reset()

func set_counter(counter: String, frame: int):
	counters[counter] = frame

func get_counter(counter: String) -> int:
	var ret = 0
	if counters.has(counter):
		ret = counters[counter]
	return ret

func get_hurt_data() -> AttackData.Information:
	return hurt_data

func pause(frame: int = 24):
	get_anim().playback_speed = 0
	paused_frame_count = frame

func resume():
	get_anim().playback_speed = 1
	paused_frame_count = 0

func air_test() -> bool:
	var shadow = get_shadow()
	if shadow != null:
		return not shadow.is_on_ground()
	return false

func _enter_tree():
	if Engine.editor_hint:
		return
	var game_scene = GameScene.current(self)
	if type == Defines.CharaterType.Ally:
		game_scene.allies.append(self)
	elif type == Defines.CharaterType.Enemy:
		game_scene.enemies.append(self)

func _exit_tree():
	if Engine.editor_hint:
		return
	if type == Defines.CharaterType.Ally:
		GameScene.current(self).allies.erase(self)
	elif type == Defines.CharaterType.Enemy:
		GameScene.current(self).enemies.erase(self)

func get_gravity():
	return GameScene.current(self).gravity * gravity_scale * _gravity_scaling

var gravity_scaling setget ,get_gravity_scaling

func get_gravity_scaling():
	return _gravity_scaling;

func distance_to(var other: Character, var z_include = false):
	var self_pos = global_transform.origin
	var other_pos = other.global_transform.origin
	if not z_include:
		self_pos.y = 0
		other_pos.y = 0
	return self_pos.distance_to(other_pos)

var position_2d: Vector2 setget , _get_position_2d

func _get_position_2d():
	var pos = global_transform.origin
	return Vector2(pos.x, pos.z)
	
func command_match(queue: Array) -> CommandManager.MatchResult:
	return get_cmds().command_match(queue)

func get_direction() -> int:
	return get_cmds().get_direction()

var absolate_speed setget set_absolate_speed, get_absolate_speed

func get_absolate_speed():
	var speed = move_speed
	if face != Face.Right:
		speed.x = -speed.x
	return speed

func set_absolate_speed(v: Vector3):
	set_move_speed(v, true)


func set_xy_speed(speed: Vector2, ignore: bool = false):
	set_move_speed(Vector3(speed.x, move_speed.y, speed.y), ignore)

func _set_xy_speed(speed: Vector2):
	self.absolate_speed = Vector3(speed.x, move_speed.y, speed.y)

func _get_xy_speed():
	var speed = self.absolate_speed
	return Vector2(speed.x, speed.z)

func set_state(v):
	if _state != v:
		_state = v
		if _state == Defines.CharacterState.Stand:
			_hurt_list.clear()
			_hurt_count = 0
			_gravity_scaling = 1
			_damage_scaling = 1
		emit_signal("state_changed", _state)

func get_state():
	return _state

func next_action_phase():
	if current_action != null:
		current_action.next_phase(tick)

func set_v_speed(v):
	move_speed.y = v

func get_v_speed():
	return move_speed.y

func invincible_in(frames: int):
	counters[Defines.InvincibleCounter] = frames

var hp: float setget set_hp, get_hp
func set_hp(v):
	if _hp != v:
		_hp = v
		emit_signal("hp_changed")
func get_hp():
	return _hp

func dead():
	_dead = true
	emit_signal("dead")

func on_hit(attack_info, target):
	pass

func shake():
	GameScene.current(self).camera.shake()

func _get_configuration_warning():
	if get_anim() == null:
		return "No anim(AnimationPlayer) found"
	if get_behav() == null:
		return "No behav(BehaviorTree) found"
	if get_shadow() == null:
		return "No shadow(Shadow) found"
	if get_boxes() == null:
		return "No boxes(Area Testers) found"
	if get_grabbed_point() == null:
		return "No grabbed_point found"
	return ""
