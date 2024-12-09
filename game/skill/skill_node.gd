class_name SkillNode extends Node

@export var skill: Skill

func _ready() -> void:
	owner.skill = skill
