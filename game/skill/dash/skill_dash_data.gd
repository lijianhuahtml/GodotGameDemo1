@tool
class_name SkillDashData extends BaseSkillData

## 冲刺速度
@export var speed: float

## 冲刺时间
@export var dash_time: float = 0:
	set(new_value):
		if dash_time != new_value:
			dash_time = max(0, new_value)
			emit_changed()
