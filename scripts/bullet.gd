extends Area2D

const SPEED = 200 # 子弹飞行速度
const RANGE = 400 # 子弹最大飞行距离

var travelled_distance = 0 # 记录子弹飞行距离

func _physics_process(delta: float) -> void:
	# Vector2.RIGHT: 表示二维向量 (1, 0)，即水平向右。
	# .rotated(rotation): 将这个向量按照当前对象的旋转角度进行旋转，得到子弹飞行的方向。
	var direction = Vector2.RIGHT.rotated(rotation)
	# direction * SPEED: 计算子弹在一秒内移动的位移。
	# * delta: 确保移动速度与帧率无关。
	# position: 表示当前节点的位置，position += 用于更新子弹的位置。
	position += direction * SPEED * delta
	# 计算子弹在本帧内移动的位移（SPEED * delta）并加到 travelled_distance 上
	travelled_distance += SPEED * delta	
	
	if travelled_distance > RANGE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
