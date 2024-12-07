@tool
class_name Skill extends Node

enum SkillType {
	Dash
}

## 技能列表
@export var skills: Array[BaseSkillData] = []
var skill_map = {}

# 冷却状态管理
var cooldowns = {}

func _ready():
	cooldowns = {}
	for i in skills.size():
		skill_map[skills[i].type] = i

# 添加技能
func add_skill(skill_config : BaseSkillData):
	skill_map[skill_config.type] = skills.size()
	skills.append(skill_config)

# 获取技能
func get_skill(type: SkillType) -> BaseSkillData:
	var index = skill_map.get(type, null)
	if index == null:
		return null
	return skills[index]

# 尝试使用技能
func try_execute(executor: Node, type : SkillType):
	if executor == null:
		return
	var skill = get_skill(type)
	if not skill:
		return
	
	# 判断冷却
	if cooldowns.get(skill.type, 0) > 0:
		return
	# 判断消耗 具有属性字段才去判断消耗
	if executor.attr is Attributes:
		if executor.attr.mp.cur < skill.cost:
			return
		executor.attr.mp.cur -= skill.cost
		print(executor.attr.mp.cur)
	
	# 执行技能逻辑
	execute(executor, skill)
	
	# 启动冷却倒计时
	start_cooldown(skill)

# 执行技能
func execute(executor: Node, skill: BaseSkillData):
	match skill.type:
		SkillType.Dash:
			add_child(SkillDash.new(executor, skill))

# 冷却计时器
func start_cooldown(skill : BaseSkillData):
	# 设置冷却
	cooldowns[skill.type] = skill.cooldown
	await get_tree().create_timer(skill.cooldown).timeout
	cooldowns[skill.type] = 0
