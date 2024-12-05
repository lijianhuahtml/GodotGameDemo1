class_name BaseSkillData extends Resource

# 技能数据
@export_custom(PROPERTY_HINT_RANGE, "0, 10000") var id: int
@export var name: String
@export_custom(PROPERTY_HINT_RANGE, "0, 10000") var cooldown: int
