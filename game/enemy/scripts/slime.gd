extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $ProgressBar


## 属性
@export var attr: Attributes
var direction = 1
var alive = true # 是否活着
var be_attacked = false
var is_running = false
var last_damage_time
var show_hp_time = 3000 # 毫秒

func _ready() -> void:
	attr.hp.changed.connect(hp_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not alive:
		return
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * attr.speed.value() * delta

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
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	queue_free()
