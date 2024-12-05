extends Node2D

@onready var map: TileMapLayer = $Map
@onready var camera_2d: Camera2D = $Player/Camera2D

func _ready() -> void:
	# 获取地图的使用信息
	var used := map.get_used_rect()
	# 获取地图的图块大小
	var map_size := map.tile_set.tile_size
	
	# 通过地图的边界设置相机的limit
	camera_2d.limit_left = used.position.x * map_size.x
	camera_2d.limit_right = used.end.x * map_size.x
	 
