extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var item_data: ItemData

var pickedup := false

func _on_body_entered(body: Node2D) -> void:
	if pickedup:
		return
	pickedup = true
	
	game_manager.add_point()
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	tween.tween_property(self, "position", (position - Vector2(0,25)), 0.3)
	tween2.tween_property(self,"modulate:a", 0, 0.3)
	animation_player.play("pickup")
	tween.tween_callback(queue_free)
	
	if body.inventory:
		body.inventory.insert(item_data)
