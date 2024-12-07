extends Area2D

func _physics_process(delta: float) -> void:
	# 获取鼠标的全局位置
	var mouse_position = get_global_mouse_position()
	
	# 让当前节点的朝向对准鼠标位置，自动调整 rotation 属性
	look_at(mouse_position)

func shoot():
	# 使用 preload() 预加载子弹场景 bullet.tscn
	const BULLET = preload("res://game/skill/bullet/bullet.tscn")	
	# 创建 bullet.tscn 的一个实例
	var new_bullet = BULLET.instantiate()
	# 将子弹的全局位置设置为发射点的全局位置。
	new_bullet.global_position = %ShootingPoint.global_position
	# 设置子弹的旋转角度与发射点一致，使子弹沿正确的方向飞行。
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	# 将生成的子弹添加为 ShootingPoint 的子节点，使其成为场景树的一部分。
	%ShootingPoint.add_child(new_bullet)

func _on_timer_timeout() -> void:
	shoot()
