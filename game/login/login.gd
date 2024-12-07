extends Node

@export var AccountInput: LineEdit
@export var PasswordInput: LineEdit

func _ready() -> void:
	Protocol.handle_rsp_10101(handle_10101)

func handle_10101(data: Protocol.rsp_10101):
	if data.get_code() == 0:
		get_tree().change_scene_to_file("res://game/room/scenes/room.tscn")
	else:
		print("handle_10101-msg: ", data.get_msg())

func _pressed() -> void:
	var data = Protocol.req_10101.new()
	data.set_account(AccountInput.text)
	data.set_password(PasswordInput.text)
	Network.send_protocol(data)
