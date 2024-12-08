extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var progress_bar: ProgressBar = $ProgressBar


const OFFSET = 20  # Boss走到玩家前面一点的距离

## 属性
@export var attr: Attributes
var alive = true # 是否活着
var is_attack = false # 是否在攻击

func _ready() -> void:
	attr.hp.changed.connect(hp_changed)

func _physics_process(delta: float) -> void:
	if not alive:
		return
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
		
	if not is_attack:	
		if player.global_position.x + OFFSET >= global_position.x and player.global_position.x - OFFSET <= global_position.x:
			velocity *= 0
			if not is_attack:
				attack()
		else:
			animated_sprite.play("move")
			# 设置速度，只在X轴方向上移动
			velocity = Vector2(move_direction.x, 0) * attr.speed.value()
	
	move_and_slide()

func hp_changed():
	progress_bar.max_value = attr.hp.max
	progress_bar.value = attr.hp.cur
	if attr.hp.cur <= 0:
		death()

func death():
	if not alive:
		return
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
