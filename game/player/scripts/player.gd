extends CharacterBody2D

# 跳跃速度
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera: Camera2D = $Camera2D
@onready var map: TileMapLayer = $"../Map"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var shooting_point: Marker2D = $ShootingPoint
@onready var ui_root: UiRoot

## 技能
@onready var skill: Skill = $Skill
## 是否锁定操作
var is_lock_operation := false
## 属性
@export var attr: Attributes
## 背包
@export var inventory: Inventory

var is_jump := false
var used
var map_size
var player_width
var direction

# velocity [默认： Vector2(0, 0)]
# 当前速度向量，单位为像素每秒
func _ready() -> void:
	ui_root = get_tree().current_scene.get_node("UiRoot")
	# 获取地图的使用信息
	used = map.get_used_rect()
	# 获取地图的图块大小
	map_size = map.tile_set.tile_size
	# 玩家CollisionShape2D宽度
	player_width = collision_shape.shape.get_rect().size.x
	attr.hp.changed.connect(hp_changed)

func _process(_delta: float) -> void:
	if is_lock_operation:
		return
	if Input.is_action_just_released("dash"):
		skill.try_execute(self, Skill.SkillType.Dash)
	if Input.is_action_pressed("shoot"):
		var running_data = {}
		running_data.pos = shooting_point.global_position
		# 计算从玩家位置到鼠标位置的方向向量
		var direction = get_global_mouse_position() - global_position
		running_data.rotation = direction.angle()
		skill.try_execute(self, Skill.SkillType.Bullet, running_data)
	if Input.is_action_just_released("inventory"):
		if !ui_root.player_inventory_ui.visible:
			ui_root.player_inventory_ui.refresh(inventory)
		ui_root.player_inventory_ui.visible = !ui_root.player_inventory_ui.visible

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("move_left", "move_right")
	
	# 翻转精灵
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	jump()
	double_jump()
	state_judgement()
	update_velocity(delta)
	move_range()

	move_and_slide()

# 单车跳跃判断逻辑
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jump = true

# 二段跳判断逻辑
func double_jump():
	if Input.is_action_just_pressed("jump") and not is_on_floor() and is_jump:
		velocity.y = JUMP_VELOCITY
		is_jump = false
		
# 角色移动边界限制
func move_range():
	# 计算地图的边界（像素单位）
	var map_left = used.position.x * map_size.x + player_width / 2
	var map_right = used.end.x * map_size.x - player_width / 2
	position.x = clamp(position.x, map_left, map_right)
	
# 角色动画状态的判断
func state_judgement():
	# 判断是否在地面上
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	elif velocity.y < 0:
		animated_sprite.play("jump")
	else:
		animated_sprite.play("fall")

# 更新调整速度velocity
func update_velocity(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var speed = attr.speed.value()
	if not is_lock_operation:
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

func hp_changed():
	pass
