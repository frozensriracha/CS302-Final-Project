extends CharacterBody2D

#pound includes
@onready var player = $"../Player"
@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
@onready var heart_scene = preload("res://Consumables/heart.tscn")

#variables
var counter1: int = 1
var counter_speed: float = 1.0
var health = 120
var random
var attack = false
var speed = 7

#process that allows for damage + shooting
func _process(delta):
	#counter so that bullets are not shot all the time
	counter1 += counter_speed + delta
	
	#if health == 0, destroy boss, randomly generate heart
	if health == 0:
		random = randf()
		print(random)
		if random > 0.8:
			var heart = heart_scene.instantiate()
			heart.position = position
			get_parent().add_child(heart)
		queue_free()
	
	
	#function to shoot bullets every once in a while
	if counter1 == 5:
		shoot()
		#reset counter
		counter1 = 0

	
	
	if attack == true:
		#make player back up so that player has chance to escape!
		position -= ((player.position - position).normalized()) * (speed)
		#take some health from player
		player.player_health = player.player_health - 3
		
		
	else:
		#if not attacking, move towards player
		position += ((player.position - position).normalized()) * (speed)
	
	#move_and_slide()

func shoot():
	#shoot bullet
	var bullet = bullet_scene.instantiate()
	bullet.type = "Boss_Bullet"
	bullet.position = position
	
	bullet.bullet_direction = (position - player.position).normalized()
	get_parent().add_child(bullet)




func _on_area_2d_body_entered(body):
	#if body entered, and body is the player, set attack to true
	if body.name == "Player":
		attack = true


#if player exits, set attack to false
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		attack = false
