extends CharacterBody2D

var chase = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var attack_area: Area2D = $Attack


## 属性
@export var attr: Attributes
var alive = true # 是否活着
var direction
var is_crash = false

func _physics_process(delta: float) -> void:
	if not alive:
		return
	if !player:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# 计算Boss和玩家的相对位置
	direction = global_position.direction_to(player.global_position)
	
	if not chase:
		velocity.x = 0
		animated_sprite.play("idle")
	elif is_crash:
		if direction.x > 0: 
			velocity.x = -50
		else:
			velocity.x = 50
	else:
		if direction.x > 0:
			animated_sprite.flip_h = true
		elif direction.x < 0:
			animated_sprite.flip_h = false
		velocity.x = direction.x * attr.speed.value()
		animated_sprite.play("walk")
		
	move_and_slide()
	
# 判断玩家是否进入驱逐区域
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true

# 判断玩家是否离开驱逐区域
func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false

# 玩家踩头顶区域进入的判断	
func _on_attack_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.velocity.y > 0:
			if alive:
				body.velocity.y = -300
			alive = false
			attack_area.monitoring = false
			animated_sprite.play("death")
			await animated_sprite.animation_finished.connect(queue_free)

# 判断玩家是否进入可攻击
func _on_attack_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if attr and body.attr:
			body.attr.take_damage(self)
			if not is_crash:
				is_crash = true
				await get_tree().create_timer(1.0).timeout
				is_crash = false
