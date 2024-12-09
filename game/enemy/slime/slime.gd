extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

## 属性
var attr: Attributes
var direction = 1
var is_alive = true # 是否活着
var is_injured = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_alive:
		return
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * attr.speed.value() * delta

func _on_life_node_on_death() -> void:
	animated_sprite.play("death")
	await animated_sprite.animation_finished
	queue_free()
