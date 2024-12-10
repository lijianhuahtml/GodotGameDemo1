extends CharacterBody2D

var player_in_area = false

func _physics_process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("dialogue"):
			run_dialogue("one")
		
func run_dialogue(dialogue_string):
	Dialogic.start(dialogue_string)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in_area = true
