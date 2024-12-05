class_name SkillDash extends Node2D

var unit
var data

func _init(unit: Node, data: Resource):
	self.unit = unit
	self.data = data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unit.velocity.x = -data.speed if unit.animated_sprite.flip_h else data.speed
	unit.is_lock_operation = true
	# 等待冲刺完成
	await get_tree().create_timer(data.dash_time).timeout
	unit.is_lock_operation = false
	queue_free()
