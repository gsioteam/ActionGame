extends Control

const colyseus = preload("res://addons/godot_colyseus/lib/colyseus.gd")
const schemas = preload("res://scenes/remote_list/schemas.gd")

const RoomUI = preload("res://scenes/remote_list/room_ui.tscn")
const Date = preload("res://addons/godot_date/date.gd")
const RoomCell = preload("res://scenes/remote_list/room_cell.tscn")

var client: colyseus.Client


# Called when the node enters the scene tree for the first time.
func _ready():
	client = colyseus.Client.new("ws://127.0.0.1:2567")
	reload()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reload():
	var promise = client.get_available_rooms(Defines.RoomName)
	print(promise.get_state())
	yield(promise, "completed")
	var result = promise.get_result()
	var list = $list/box
	for child in list.get_children():
		child.queue_free()
	for room_info in result:
		var cell = RoomCell.instance()
		cell.text = room_info.name
		cell.data = room_info
		list.add_child(cell)
		cell.connect("button_click", self, "_on_enter_room")
		

func _on_create_pressed():
	$loading.popup_centered()
	var promise: colyseus.Promise = client.create(schemas.RoomState, "game_room")
	promise = yield(promise.await(), "completed")
	$loading.hide()
	if promise.get_state() == colyseus.Promise.State.Success:
		var room = promise.get_result()
		var room_ui = RoomUI.instance()
		room_ui.room = room
		get_parent().add_child(room_ui)
		queue_free()
	else:
		$alert.dialog_text = str("Error:", promise.get_error())
		$alert.popup_centered()

func _on_refresh_pressed():
	reload()

func _on_cancel_pressed():
	get_tree().change_scene("res://ui/main_menu/main_menu.tscn")

func _on_enter_room(room_cell):
	var data: colyseus.RoomInfo = room_cell.data
	var promise = yield(client.join_by_id(schemas.RoomState, data.room_id).await(), "completed")
	if promise.get_state() == colyseus.Promise.State.Success:
		var room = promise.get_result()
		var room_ui = RoomUI.instance()
		room_ui.room = room
		get_parent().add_child(room_ui)
		queue_free()
	else:
		$alert.dialog_text = str("Error:", promise.get_error())
		$alert.popup_centered()
