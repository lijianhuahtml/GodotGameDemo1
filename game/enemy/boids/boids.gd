extends Node2D

@onready var player: CharacterBody2D = $"../../Player"

@export var BoidScene: PackedScene
@export var boid_count = 50
var boids = []

signal boid_death(index: int)

#func _ready():
	#boid_death.connect(on_boid_death)
	## 实例化 Boids
	#for i in range(boid_count):
		#var boid = BoidScene.instantiate()
		#boid.global_position = player.global_position - Vector2(500, 500) + Vector2(randf() * 1000, randf() * 1000)
		#add_child(boid)
		#boids.append(boid)

func _process(delta):
	# 更新每个 Boid 的状态
	for i in range(boids.size() - 1, -1, -1):
		if boids[i] != null:
			boids[i].flock(boids, player.global_position)
		else:
			boids.remove_at(i)

func on_boid_death(index: int):
	boids.remove_at(index)
