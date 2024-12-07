@tool
class_name BaseSkillData extends Resource

## 技能ID
@export var type: Skill.SkillType

## 技能名称
@export var name: String

## 冷却时间 范围：[0, ...)
@export var cooldown: float = 0:
	set(new_value):
		if cooldown != new_value:
			cooldown = max(0, new_value)
			emit_changed()

## 消耗 范围：[0, ...)
@export var cost: float = 0:
	set(new_value):
		if cost != new_value:
			cost = max(0, new_value)
			emit_changed()
