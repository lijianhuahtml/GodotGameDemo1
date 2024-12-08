extends CharacterBody2D

var chase = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = $"../../Player"

## 属性
@export var attr: Attributes
var alive = true # 是否活着

func _physics_process(delta: float) -> void:
	if not alive:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if not chase:
		velocity.x = 0
		animated_sprite.play("idle")
	else:
		# 计算Boss和玩家的相对位置
		var direction = global_position.direction_to(player.global_position)
		
		if direction.x > 0.0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		velocity.x = direction.x * attr.speed.value()
		animated_sprite.play("walk")
		
	move_and_slide()
	
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		chase = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false
	
func _on_attack_entered(body: Node2D) -> void:
	if body.name == "Player":
		if alive:
			body.velocity.y = -300
		alive = false
		animated_sprite.play("death")
		await animated_sprite.animation_finished.connect(queue_free)
		
