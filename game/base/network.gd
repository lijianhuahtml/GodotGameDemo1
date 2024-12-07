extends Node


# 服务器 IP 和端口
var SERVER_IP = "127.0.0.1"
var SERVER_PORT = 12000

# StreamPeerTCP 对象
var client := StreamPeerTCP.new()


func _ready():
	# 尝试连接服务器
	reconnect()
	set_process(true)

func _process(_delta):
	# 检查连接状态
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		# 检查是否有数据可读取
		if client.get_available_bytes() > 0:
			var data_size = client.get_u32()
			var code = client.get_u16()
			var data = client.get_data(data_size - 2)[1]
			var bytes = PackedByteArray(data)
			var msg_name = "rsp_" + str(code)
			var signal_name = "recv_" + msg_name
			var msg_class = Protocol.get(msg_name)
			if Protocol.has_signal(signal_name) and msg_class != null:
				var msg = msg_class.new()
				msg.from_bytes(bytes)
				Protocol.emit_signal(signal_name, msg)
	elif client.get_status() == StreamPeerTCP.STATUS_ERROR:
		print("Connection error.")
		set_process(false)


func send_protocol(data: Object) -> int:
	if not data.has_method("_get_type"):
		return 1
	var type_name = data._get_type()
	var names = type_name.split("_")
	if names.size() < 2 or names[0] != "req":
		return 1
	var code = int(names[1])
	if code == 0:
		return 1
	var bytes = data.to_bytes()
	var data_size = 2 + bytes.size()
	client.put_u32(data_size)
	client.put_u16(code)
	client.put_data(bytes)
	return 0

func reconnect(ip: String = SERVER_IP, port: int = SERVER_PORT) -> void:
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		client.disconnect_from_host()
	
	client.set_big_endian(true)

	var connection_status = client.connect_to_host(ip, port)
	if connection_status == OK:
		print("Connecting to server...")
	else:
		print("Failed to connect to server.")
	client.poll()
