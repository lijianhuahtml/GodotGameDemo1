#@tool
class_name Item extends RigidBody2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var item_data: ItemData

# 设置浮动参数
@export var float_height := 10.0  # 浮动高度
@export var float_duration := 1.0  # 浮动持续时间

var pickedup := false
var float_tween: Tween
var start_position: Vector2
var target_position: Vector2

func _ready() -> void:
	refresh()

func refresh(_item_data: ItemData = null):
	if _item_data:
		item_data = _item_data
	if !item_data:
		return
	
	animated_sprite_2d.sprite_frames.clear_all()
	
	if item_data.sprites:
		for anim in item_data.sprites.get_animation_names():
			animated_sprite_2d.sprite_frames.add_animation(anim)
			animated_sprite_2d.sprite_frames.set_animation_speed(anim, item_data.sprites.get_animation_speed(anim))
			for i in item_data.sprites.get_frame_count(anim):
				animated_sprite_2d.sprite_frames.add_frame(anim, item_data.sprites.get_frame_texture(anim, i), item_data.sprites.get_frame_duration(anim, i), i)
		animated_sprite_2d.play("default")
		sprite_2d.texture = null
		animated_sprite_2d.visible = true
		sprite_2d.visible = false
	elif item_data.icon:
		sprite_2d.texture = item_data.icon
		animated_sprite_2d.visible = false
		sprite_2d.visible = true

func start_floating():
	float_tween = get_tree().create_tween()
	# 使用 Tween 实现上下浮动
	float_tween.tween_property(self, "position", position, float_duration)
	float_tween.tween_property(self, "position", position + Vector2(0, -float_height), float_duration)
	# 循环播放
	float_tween.set_loops()
	float_tween.play()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		if !float_tween:
			# 启动浮动动画
			start_floating()
		return
	
	if pickedup:
		return
	pickedup = true
	
	game_manager.add_point()
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "position", (position - Vector2(0,25)), 0.3)
	tween2.tween_property(self,"modulate:a", 0, 0.3)
	tween.tween_callback(queue_free)
	
	if animated_sprite_2d.sprite_frames:
		animation_player.play("pickup")
	
	body.inventory.insert(item_data)
