extends CharacterBody2D

# 速度
const SPEED = 130.0
# 跳跃速度
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D

@export var skill: Skill
var is_lock_operation := false

var is_jump := false

# velocity [默认： Vector2(0, 0)]
# 当前速度向量，单位为像素每秒

func _process(delta: float) -> void:
	if is_lock_operation:
		return
	if Input.is_action_just_released("dash"):
		skill.use_skill(0)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
	
	if Input.is_action_just_pressed("jump") and not is_on_floor() and is_jump:
		velocity.y = JUMP_VELOCITY
		is_jump = false

	# 如果不按下如何按钮 direction = 0
	# 如果按下左键 direction = -1
	# 如果按下右键 direction = 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# 翻转精灵
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# 判断是否在地面上
	if is_on_floor():
		
		# 如果没有操作
		if direction == 0:
			# 播放闲置动画
			animated_sprite.play("idle")
		else:
			# 播放奔跑动画
			animated_sprite.play("run")		
	# 离开地面
	else:
		# 播放跳跃动画
		animated_sprite.play("jump")	

	if not is_lock_operation:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
