@tool
extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $ProgressBar


@export var attr: Attributes
var be_attacked = false
var is_running = false
var last_damage_time # 最后一次受到伤害的时间戳
var show_hp_time = 3000 # 血条显示时间（毫秒）

## 最大转向力
@export var max_force = 10:
	set(new_value):
		new_value = max(0, new_value)
		if max_force != new_value:
			max_force = new_value

## 分离半径
@export var perception_radius = 1000:
	set(new_value):
		new_value = max(0, new_value)
		if perception_radius != new_value:
			perception_radius = new_value

## 对齐权重 影响鸟群向整体方向移动的权重
@export var alignment_weight = 1.0:
	set(new_value):
		new_value = max(0, new_value)
		if alignment_weight != new_value:
			alignment_weight = new_value

## 聚合权重 影响鸟群向目标点移动的权重
@export var cohesion_weight = 0.5:
	set(new_value):
		new_value = max(0, new_value)
		if cohesion_weight != new_value:
			cohesion_weight = new_value

## 分离权重 影响鸟群远离其他鸟的权重
@export var separation_weight = 10.0:
	set(new_value):
		new_value = max(0, new_value)
		if separation_weight != new_value:
			separation_weight = new_value

var alive = true

# 当前速度
var velocity = Vector2.ZERO
# 加速度
var acceleration = Vector2.ZERO

func _ready() -> void:
	attr.hp.changed.connect(hp_changed)

func _process(delta):
	# 更新位置
	velocity += acceleration
	velocity = velocity.normalized() * attr.speed.value()
	global_position += velocity * delta

	# 翻转精灵
	if velocity.x > 0:
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true

	# 清除加速度
	acceleration = Vector2.ZERO

# 应用力
func apply_force(force: Vector2):
	acceleration += force

# 三大规则
func flock(boids: Array, pos: Vector2):
	var alignment = align(boids)
	var cohesion = (pos - global_position).normalized() * max_force
	var separation = separate(boids)

	# 加权合并
	apply_force(alignment * alignment_weight)
	apply_force(cohesion * cohesion_weight)
	apply_force(separation * separation_weight)

# 对齐：朝向邻居的平均方向
func align(boids: Array) -> Vector2:
	var steering = Vector2.ZERO
	var total = 0

	for other in boids:
		if !other or other == self:
			continue
		if global_position.distance_to(other.global_position) < perception_radius:
			steering += other.velocity
			total += 1

	if total > 0:
		steering /= total
		steering = steering.normalized() * attr.speed.value()
		steering -= velocity
		steering = steering.normalized() * max_force
	return steering

# 分离：远离太近的邻居
func separate(boids: Array) -> Vector2:
	var steering = Vector2.ZERO
	var total = 0

	for other in boids:
		if !other:
			continue
		var distance = global_position.distance_to(other.global_position)
		if other != self and distance < perception_radius:
			var diff = global_position - other.global_position
			diff /= distance
			steering += diff
			total += 1

	if total > 0:
		steering /= total
		steering = steering.normalized() * attr.speed.value()
		steering -= velocity
		steering = steering.normalized() * max_force
	return steering

func _on_body_entered(body: Node2D) -> void:
	if body.attr:
		body.attr.take_damage(attr)

func hp_changed():
	last_damage_time = Time.get_ticks_msec() + show_hp_time
	be_attacked = true
	progress_bar.visible = true
	progress_bar.max_value = attr.hp.max
	progress_bar.value = attr.hp.cur
	if attr.hp.cur <= 0:
		death()
	else:
		if not be_attacked or not is_running:
			_delayed_hide_bar()

# 协程函数：延迟隐藏血条
func _delayed_hide_bar() -> void:
	is_running = true
	while true:
		be_attacked = false
		await get_tree().create_timer((last_damage_time - Time.get_ticks_msec())/1000).timeout
		if not be_attacked:
			break 
	progress_bar.visible = false	
	is_running = false

func death():
	if not alive:
		return
	alive = false
	queue_free()
