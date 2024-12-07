extends CharacterBody2D

# 跳跃速度
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var map: TileMapLayer = $"../Map"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


## 技能
@onready var skill: Skill = $Skill
## 是否锁定操作
var is_lock_operation := false
## 属性
@export var attr: Attributes

var is_jump := false
var used
var map_size
var player_width

# velocity [默认： Vector2(0, 0)]
# 当前速度向量，单位为像素每秒
func _ready() -> void:
	print("111")
	# 获取地图的使用信息
	used = map.get_used_rect()
	# 获取地图的图块大小
	map_size = map.tile_set.tile_size
	# 玩家CollisionShape2D宽度
	player_width = collision_shape.shape.get_rect().size.x


func _process(_delta: float) -> void:
	if is_lock_operation:
		return
	if Input.is_action_just_released("dash"):
		skill.try_execute(self, Skill.SkillType.Dash)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true
	
	# 二段跳的判断逻辑
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
	elif velocity.y < 0:
		# 播放跳跃上升动画
		animated_sprite.play("jump")
	else:
		# 播放跳跃下降动画
		animated_sprite.play("fall")	
	
	var speed = attr.speed.value()
	if not is_lock_operation:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
	# 计算地图的边界（像素单位）
	var map_left = used.position.x * map_size.x + player_width / 2
	var map_right = used.end.x * map_size.x - player_width / 2
	
	position.x = clamp(position.x, map_left, map_right)

	move_and_slide()
