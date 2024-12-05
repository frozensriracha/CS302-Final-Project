extends CharacterBody2D
@onready var player = $"../Player"
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var half_heart_scene = preload("res://Consumables/half_heart.tscn")

#variables
var speed = 1
var counter = 0
var attack = false
var health = 15
var random



func _physics_process(delta):
	counter += counter + delta
	
	
	#if glob health is zero, randomly generate heart or half-heart, and queue_free()
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
	
	#if attack true, take health from player and move slightly away from player (So player does not get trapped)
	if attack == true:
		position -= ((player.position - position).normalized()) * (speed)
		if counter > 10000:
			player.player_health = player.player_health - 1 
			counter = 0


	#if attack false, just move towards player
	else:
		position += ((player.position - position).normalized()) * (speed)
	
	move_and_slide()



#Functions to send signal if glob enters the player or not
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		attack = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		attack = false
	
	
