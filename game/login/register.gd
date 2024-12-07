extends Panel

@export var AccountInput: LineEdit
@export var PasswordInput: LineEdit

func _ready() -> void:
	Protocol.handle_rsp_10100(handle_10100)

func handle_10100(data: Protocol.rsp_10100):
	var data1 = data.clone()
	print("handle_10100-msg: ", data1.get_msg())

func _pressed() -> void:
	var data = Protocol.req_10100.new()
	data.set_account(AccountInput.text)
	data.set_password(PasswordInput.text)
	Network.send_protocol(data)
