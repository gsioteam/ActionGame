extends Character2D

export (int) var max_energy = 100
var _energy: float

var energy: float setget set_energy, get_energy

signal energy_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	_energy = max_energy

func set_energy(v):
	if _energy != v:
		_energy = v
		emit_signal("energy_changed")
		
func get_energy():
	return _energy

func can_cast(energy):
	return _energy > energy or self.hp > 30

func cast(energy):
	if self.energy > energy:
		self.energy -= energy
	else:
		self.hp -= 10
		self.energy = (self.energy + max_energy) - energy

var _old_ai
func on_hit(attack_info, target):
	if _old_ai == attack_info:
		return
	_old_ai = attack_info
	self.energy = min(max_energy, self.energy + 2)
