@tool
extends Node2D

## 血条的高度
@export var life_bar_offset := Vector2(0, -50)
@export var life_bar_size := Vector2(34, 3)
## 是否开启血条隐藏效果
@export var is_open_hide_life_bar_effect := true

@onready var life_bar: ProgressBar = $LifeBar

var hp: AttributesCons

# 血条隐藏所用变量
var is_running = false
var last_damage_time
var show_hp_time = 3000 # 毫秒

signal on_death

func _ready() -> void:
	# 是否活着
	owner.is_alive = true
	owner.is_injured = false
	hp = owner.attr.hp
	hp.changed.connect(_on_hp_changed)
	life_bar.size = life_bar_size
	life_bar_offset.x -= life_bar_size.x / 2
	life_bar.position = life_bar_offset

func _on_hp_changed():
	last_damage_time = Time.get_ticks_msec() + show_hp_time
	owner.is_injured = true
	
	life_bar.visible = true
	life_bar.max_value = hp.max
	life_bar.value = hp.cur
	
	if hp.cur <= 0:
		death()
	elif is_open_hide_life_bar_effect:
		if not owner.is_injured or not is_running:
			_delayed_hide_bar()
			
# 协程函数：延迟隐藏血条
func _delayed_hide_bar() -> void:
	is_running = true
	while true:
		owner.is_injured = false
		await get_tree().create_timer((last_damage_time - Time.get_ticks_msec())/1000).timeout
		if not owner.is_injured:
			break 
	life_bar.visible = false	
	is_running = false

func death():
	if !owner.is_alive:
		return
	owner.is_alive = false
	on_death.emit()
