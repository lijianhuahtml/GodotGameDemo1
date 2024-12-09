@tool
extends Node2D

## 血条的高度
@export var life_bar_offset := Vector2(0, -50)
@export var life_bar_size := Vector2(34, 3)

@onready var life_bar: ProgressBar = $LifeBar

var hp: AttributesCons

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
	life_bar.max_value = hp.max
	life_bar.value = hp.cur
	owner.is_injured = true
	if hp.cur <= 0:
		death()

func death():
	if !owner.is_alive:
		return
	owner.is_alive = false
	on_death.emit()
