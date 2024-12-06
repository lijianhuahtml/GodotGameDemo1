extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tween_fade.finished
	queue_free()
