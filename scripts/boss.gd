extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../Player"
@onready var progress_bar: ProgressBar = $ProgressBar

const SPEED = 40 # 行走速度
const OFFSET = 20  # Boss走到玩家前面一点的距离

var hp = 100.0 # 血量
	
func _physics_process(delta: float) -> void:
	# 计算Boss和玩家的相对位置
	var direction = global_position.direction_to(player.global_position)
	
	if direction.x > 0.0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
		
	 # 计算目标位置，Boss走到玩家的前面一点
	var target_position = player.global_position + direction * OFFSET
	# 计算Boss向目标位置的方向
	var move_direction = (target_position - global_position).normalized()
	
	if player.global_position.x + OFFSET >= global_position.x and player.global_position.x - OFFSET <= global_position.x:
		velocity *= 0
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("move")
		# 设置速度，只在X轴方向上移动
		velocity = Vector2(move_direction.x, 0) * SPEED
		
	progress_bar.value = hp
	
	move_and_slide()
