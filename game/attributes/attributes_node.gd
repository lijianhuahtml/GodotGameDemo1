class_name AttributesNode extends Node

@export var attr: Attributes

func _ready() -> void:
	owner.attr = attr
	attr.on_take_damage.connect(_on_take_damage)

func _on_take_damage(other: Node2D):
	other.attr.on_cause_damage.emit(owner)
