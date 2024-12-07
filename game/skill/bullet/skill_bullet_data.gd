@tool
class_name SkillBulletData extends BaseSkillData

## 飞行速度
@export var speed: float

## 飞行距离
@export var range: float = 0:
	set(new_value):
		if range != new_value:
			range = max(0, new_value)
			emit_changed()
