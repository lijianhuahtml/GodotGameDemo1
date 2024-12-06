extends Node2D

@onready var map: TileMapLayer = $Map
@onready var camera_2d: Camera2D = $Player/Camera2D


func _ready() -> void:
	# 获取地图的使用信息
	var used := map.get_used_rect()
	# 获取地图的图块大小
	var map_size := map.tile_set.tile_size
	
	# 计算地图的边界（像素单位）
	var map_left = used.position.x * map_size.x
	var map_right = used.end.x * map_size.x
	#var map_top = used.position.y * map_size.y
	#var map_bottom = used.end.y * map_size.y
	
	# 设置相机限制
	camera_2d.limit_left = map_left
	camera_2d.limit_right = map_right
	#camera_2d.limit_top = map_top
	#camera_2d.limit_bottom = map_bottom
