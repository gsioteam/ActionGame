extends HBoxContainer

const schemas = preload("res://scenes/remote_list/schemas.gd")

var player: schemas.PlayerSchema
var _handler

signal state_change

func _ready():
	_update()
	_handler = funcref(self, "_on_change")
	player.listen(':change').on(_handler)

func _exit_tree():
	player.listen(':change').off(_handler)

func _update():
	$name.text = player.name
	match player.state:
		0:
			$state.text = 'Waiting'
		1:
			$state.text = 'Ready'

func _on_change(current):
	_update()
	emit_signal("state_change", player)
