class_name SkillDash extends Node2D

var dash_sfx = preload("res://assets/sounds/dash.wav")

var unit
var data
var audio_player
var ghost_vfx = preload("res://scripts/vfx/ghost_vfx.gd")

func _init(unit: Node, data: Resource):
	self.unit = unit
	self.data = data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = dash_sfx
	audio_player.play()
	unit.velocity.x = -data.speed if unit.animated_sprite.flip_h else data.speed
	unit.is_lock_operation = true
	ghost_vfx = GhostVfx.new(unit.animated_sprite)
	add_child(ghost_vfx)
	# 等待冲刺完成
	await get_tree().create_timer(data.dash_time).timeout
	unit.is_lock_operation = false
	ghost_vfx.queue_free()
	await audio_player.finished
	queue_free()
