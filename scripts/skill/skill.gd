# Character.gd
class_name Skill extends Node

@export var unit: Node

# 技能列表
@export var skills = {}

# 冷却状态管理
var cooldowns = {}

func _ready():
	cooldowns = {}

# 添加技能
func add_skill(skill_config : Resource):
	skills[skill_config.id] = skill_config

# 执行技能
func use_skill(id : int):
	var skill = skills.get(id, null)
	if not skill or cooldowns.get(skill.id, 0) > 0:
		return

	# 执行技能逻辑
	if skill.id == 0:
		add_child(SkillDash.new(unit, skill))

	# 启动冷却倒计时
	start_cooldown(skill)

# 冷却计时器
func start_cooldown(skill : Resource):
	# 设置冷却
	cooldowns[skill.id] = skill.cooldown
	await get_tree().create_timer(skill.cooldown).timeout
	cooldowns[skill.id] = 0
