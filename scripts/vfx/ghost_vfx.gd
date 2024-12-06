class_name GhostVfx extends Node

var ghost_vfx = preload("res://scenes/vfx/ghost.tscn")

var animated_sprite: AnimatedSprite2D

func _init(animated_sprite: AnimatedSprite2D):
	self.animated_sprite = animated_sprite
	
func _process(_delta: float) -> void:
	if animated_sprite == null:
		return
	
	var ghost = ghost_vfx.instantiate()
	ghost.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
	ghost.global_position = animated_sprite.global_position
	ghost.flip_h = animated_sprite.flip_h
	get_tree().current_scene.add_child(ghost)
