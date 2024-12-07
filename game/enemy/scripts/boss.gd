extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var progress_bar: ProgressBar = $ProgressBar

const SPEED = 40 # 行走速度
const OFFSET = 20  # Boss走到玩家前面一点的距离

var hp = 100.0 # 血量
var alive = true # 是否活着
var is_attack = false # 是否在攻击

	
func _physics_process(delta: float) -> void:
	# 计算Boss和玩家的相对位置
	var direction = global_position.direction_to(player.global_position)
	
	if direction.x > 0.0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
		
	 # 计算目标位置，Boss走到玩家的前面一点
	var target_position = player.global_position + direction * OFFSET
	# 计算Boss向目标位置的方向
	var move_direction = (target_position - global_position).normalized()
		
	if alive and not is_attack:	
		if player.global_position.x + OFFSET >= global_position.x and player.global_position.x - OFFSET <= global_position.x:
			velocity *= 0
			if not is_attack:
				attack()
		else:
			animated_sprite.play("move")
			# 设置速度，只在X轴方向上移动
			velocity = Vector2(move_direction.x, 0) * SPEED
	
	move_and_slide()


func take_damage():
	hp -= 10
	progress_bar.value = hp
	if hp <= 0:
		death()

func death():
	alive = false
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	queue_free()
	
func attack():
	is_attack = true
	
	var attack_animations = ["attack1", "attack2", "attack3", "attack4"]
	var random_attack = attack_animations[randi() % attack_animations.size()]
	
	animated_sprite.play(random_attack)
	
	await animated_sprite.animation_finished
	is_attack = false
