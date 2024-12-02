extends CharacterBody2D
@onready var player = $"../Player"
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var half_heart_scene = preload("res://Consumables/half_heart.tscn")

var speed = 1
#var player_chase = false
var counter = 0
var attack = false
var health = 15
var random


#func _ready():
	#var player = get_node("/root/GlobRoom/Player")

func _physics_process(delta):
	counter += counter + delta
	#print(player.player_health)
	
	if health == 0:
		random = randf()
		if random > 0.8:
			if random > 0.9:
				var heart = heart_scene.instantiate()
				heart.position = position
				get_parent().add_child(heart)
			else:
				var half_heart = half_heart_scene.instantiate()
				half_heart.position = position
				get_parent().add_child(half_heart)
		get_parent().enemyCount - 1
		queue_free()
	
	if attack == true:
		position -= ((player.position - position).normalized()) * (speed)
		if counter > 10000:
			#print("HERE2")
			player.player_health = player.player_health - 1 
			counter = 0
		#if player.name == "Player":
		
	else:
		position += ((player.position - position).normalized()) * (speed)
	
	move_and_slide()




func _on_area_2d_body_entered(body):
	
	if body.name == "Player":
		#print("ENTERED")
		#player.health = player.health - 1
		attack = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		#print("EXITED")
		attack = false
	
	
