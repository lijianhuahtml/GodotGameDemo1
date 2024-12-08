class_name SkillBullet extends Node

# 使用 preload() 预加载子弹场景 bullet.tscn
const BULLET = preload("res://game/skill/bullet/bullet.tscn")

var executor: Node
var data: SkillBulletData
var rotation: float
var pos: Vector2

func _init(executor: Node, data: SkillBulletData, running_data):
	self.executor = executor
	self.data = data
	self.rotation = running_data.rotation
	self.pos = running_data.pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 创建 bullet.tscn 的一个实例
	var bullet = BULLET.instantiate()
	bullet.set_data(executor, data)
	# 将子弹的全局位置设置为发射点的全局位置。
	bullet.global_position = pos
	# 设置子弹的旋转角度与发射点一致，使子弹沿正确的方向飞行。
	bullet.global_rotation = rotation
	# 将生成的子弹添加为 ShootingPoint 的子节点，使其成为场景树的一部分。
	get_tree().current_scene.add_child(bullet)
