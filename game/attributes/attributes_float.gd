@tool
class_name AttributesFloat extends Resource

## 基础值 计算公式：最终值 = 基础值 * 乘值 + 加值
@export var base: float:
	set(new_value):
		if base != new_value:
			base = new_value
			emit_changed()
			
## 加区 在最终值上进行加法运算 计算公式：最终值 = 基础值 * 乘值 + 加值
@export var add: float:
	set(new_value):
		if add != new_value:
			add = new_value
			emit_changed()
			
## 乘区 在基础值上进行乘法运算 计算公式：最终值 = 基础值 * 乘值 + 加值
@export var mul: float = 1:
	set(new_value):
		if mul != new_value:
			mul = new_value
			emit_changed()

## 获取最终值
func value() -> float:
	return base * mul + add

## 合并属性
func merge(attr: AttributesFloat):
	if attr == null:
		return
	
	base += attr.base
	add += attr.add
	mul += attr.mul

## 分离属性
func split(attr: AttributesFloat):
	if attr == null:
		return
	
	base -= attr.base
	add -= attr.add
	mul -= attr.mul
