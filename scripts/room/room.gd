extends Node

@export var list_view: BoxContainer

var room_id
var role_list

var room_list

func _ready() -> void:
	Protocol.handle_rsp_10200(handle_10200)
	var data = Protocol.req_10200.new()
	Network.send_protocol(data)

func handle_10200(data: Protocol.rsp_10200) -> void:
	room_id = data.get_room().get_id()
	role_list = data.get_room().get_role_list()
	room_list = data.get_room_list()
	list_view.update(room_list)
	print("handle_10200")

func create_room():
	var data = Protocol.req_10201.new()
	Network.send_protocol(data)
