extends Resource

class_name AttackData

enum HurtState {
	Launched,
	Smashed,
	Grabbed,
	Stun,
	Down,
	Wake
}

enum AttackType {
	Hit,
	Launch,
	Smash,
	Grab,
	Throw,
}

enum DirectionType {
	Fix,
	Attracts,
	Repulsion,
}

export(float) var power = 24
export(int) var damage = 5
export(AttackType) var attack_type = AttackType.Hit
export(DirectionType) var direction_type = DirectionType.Fix
export(Vector3) var direction = Vector3(2,3,0)
export(String) var relative_point_name

export(PackedScene) var spark_scene
export(int) var self_pause = 6
export(int, LAYERS_3D_PHYSICS) var target_state_mask = (1 << Defines.CharacterState.Stand) | (1 << Defines.CharacterState.Pain) | (1 << Defines.CharacterState.Air) | (1 << Defines.CharacterState.Launched)

export(float) var gravity_scaling = 1.05
export(float) var damage_scaling = 0.95

export (int) var launch_damage = 0

class Information:
	var power: float
	var direction: Vector3
	var damage: int
	var attack_type: int
	var direction_type: int = DirectionType.Fix
	
	var run_count = 0
	var face: int
	
	var from
	var relative_point: Spatial
	var self_pause: int
	var spark_scene: PackedScene
	var target_state_mask: int
	
	var resource
	var repeat: bool = false
	
	var gravity_scaling: float
	var damage_scaling: float
	
	var launch_damage: int
	
	func _init(power, direction, damage, attack_type):
		self.power = power
		self.direction = direction
		self.damage = damage
		self.attack_type = attack_type

func get_info(relative_point: Spatial = null) -> Information:
	var info = Information.new(power, direction, damage, attack_type)
	info.relative_point = relative_point
	info.self_pause = self_pause
	info.spark_scene = spark_scene
	info.target_state_mask = target_state_mask
	info.direction_type = direction_type
	info.resource = self
	info.gravity_scaling = gravity_scaling
	info.damage_scaling = damage_scaling
	info.launch_damage = launch_damage
	return info
