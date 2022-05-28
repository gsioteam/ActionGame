tool
extends Control

const Gauge = preload("res://tools/char/gauge.gd")

export (Texture) var avatar setget set_avatar, get_avatar
export (NodePath) var target_path

var _avatar
var target: Character

var _hp: Gauge
var _avatar_texture

var _tp: Gauge

func _ready():
	if target == null:
		target = get_node(target_path)
	target.connect("damage", self, "_on_damage")
	target.connect("hp_changed", self, "_on_hp_changed")
	target.connect("energy_changed", self, "_on_energy_changed")
	_hp = $hp
	_avatar_texture = $avatar
	_avatar_texture.texture = _avatar
	_hp.percent = target.hp / target.max_hp
	
	_tp = $tp
	_tp.percent = target.energy / target.max_energy

func set_avatar(v):
	if _avatar != v:
		_avatar = v
		if _avatar_texture != null:
			_avatar_texture.texture = _avatar

func get_avatar():
	return _avatar

func _on_damage(dmg):
	_hp.percent = target.hp / target.max_hp

func _on_hp_changed():
	_hp.percent = target.hp / target.max_hp

func _on_energy_changed():
	_tp.percent = target.energy / target.max_energy
