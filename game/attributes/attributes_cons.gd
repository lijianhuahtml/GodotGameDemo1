@tool
class_name AttributesCons extends Resource

## 最大值 范围：[0, ...)
@export var max: float:
	set(new_value):
		if max != new_value:
			max = max(0, new_value)
			cur = clamp(cur, 0, max)
			emit_changed()

## 当前值 范围：[0, max]
@export var cur: float:
	set(new_value):
		new_value = clamp(new_value, 0, max)
		if cur != new_value:
			cur = new_value
			emit_changed()

## 合并属性
func merge(attr: AttributesCons):
	if attr == null:
		return
	
	max += attr.max
	cur += cur
