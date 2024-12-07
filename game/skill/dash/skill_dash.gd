class_name SkillDash extends Node2D

const dash_sfx = preload("res://assets/sounds/dash.wav")

var executor: Node
var data: SkillDashData
var audio_player := AudioStreamPlayer.new()
var ghost_vfx: GhostVfx

func _init(executor: Node, data: SkillDashData):
	self.executor = executor
	self.data = data

func _ready() -> void:
	executor.is_lock_operation = true
	
	# 播放音效
	add_child(audio_player)
	audio_player.stream = dash_sfx
	audio_player.play()
	executor.velocity.x = -data.speed if executor.animated_sprite.flip_h else data.speed
	
	# 残影效果
	ghost_vfx = GhostVfx.new(executor.animated_sprite)
	add_child(ghost_vfx)
	
	# 等待冲刺完成
	await get_tree().create_timer(data.dash_time).timeout
	executor.is_lock_operation = false
	ghost_vfx.queue_free()
	await audio_player.finished
	queue_free()
