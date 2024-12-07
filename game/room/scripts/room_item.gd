extends Node

@export var room_id: Label
@export var room_size: Label

var room: Protocol.pb_room

func update(room: Protocol.pb_room):
	self.room = room
	room_id.text = str(room.get_id())
	room_size.text = str(room.get_role_list().size())

func join() -> void:
	var data = Protocol.req_10202.new()
	data.set_id(room.get_id())
	Network.send_protocol(data)
