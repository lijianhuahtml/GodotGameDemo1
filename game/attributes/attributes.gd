@tool
class_name Attributes extends Resource

## 生命值 消耗值：具有最大值、当前值。 当前值范围：[0, max]；最大值范围：[0, ...)
@export var hp := AttributesCons.new()

## 魔法值 消耗值：具有最大值、当前值。 当前值范围：[0, max]；最大值范围：[0, ...)
@export var mp := AttributesCons.new()

## 物理攻击 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var p_atk := AttributesFloat.new()

## 法术攻击 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var m_atk := AttributesFloat.new()

## 物理防御 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var p_def := AttributesFloat.new()

## 法术防御 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var m_def := AttributesFloat.new()

## 速度 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var speed := AttributesFloat.new()

## 暴击率 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var crit := AttributesFloat.new()

## 暴击倍率 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var crit_rate := AttributesFloat.new()

## 闪避 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var eva := AttributesFloat.new()

## 增伤 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var dmg_inc := AttributesFloat.new()

## 减伤 浮动值：具有基础值、加值、乘值。计算公式：最终值 = 基础值 * 乘值 + 加值
@export var dmg_red := AttributesFloat.new()

# 承受伤害
func take_damage(attrs: Attributes):
	# 计算闪避
	var is_evasion = randf() * 100 < eva.value()
	if is_evasion:
		return
	
	var damage = 0
	# 计算所有攻击造成的基础伤害：对方物理攻击 - 己方物理防御 + 对方法术攻击 - 己方法术防御
	damage += attrs.p_atk.value() - p_def.value()
	damage += attrs.m_atk.value() - m_def.value()
	# 计算暴击
	var is_critical = randf() * 100 < attrs.crit.value()
	var critical = attrs.crit_rate.value() / 100 if is_critical else 1
	# 计算最终伤害（未闪避）：基础伤害 * 对方暴击伤害 * 对方增伤 / 己方减伤
	damage = damage * critical * (attrs.dmg_inc.value() + 100) / 100 / ((dmg_red.value() + 100) / 100)
	hp.cur -= damage

# 合并另一个属性到自身
func merge(attrs: Attributes):
	if attrs == null:
		return
	
	for attr_name in get_meta_list():
		var self_attr = get(attr_name)
		var other_attr = attrs.get(attr_name)
		if self_attr == null or other_attr == null:
			continue
		self_attr.merge(other_attr)
