extends CharacterBody2D

#pound includes
@onready var player = $"../Player"
@onready var blue_bullet_scene = preload("res://Boss_Bullet/blue_boss_bullet.tscn")
@onready var yellow_bullet_scene = preload("res://Boss_Bullet/yellow_boss_bullet.tscn")
@onready var red_bullet_scene = preload("res://Boss_Bullet/red_boss_bullet.tscn")
@onready var purple_bullet_scene = preload("res://Boss_Bullet/purple_boss_bullet.tscn")
@onready var green_bullet_scene = preload("res://Boss_Bullet/green_boss_bullet.tscn")
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var win_screen_scene = preload("res://MenuScreens/win_screen.tscn")

#variables
var counter1: int = 1
var helper
var counter_speed: float = 1.0
var health = 5
var random
var attack = false
var speed = 5

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
		get_parent().enemyCount - 1
		var win = win_screen_scene.instantiate()
		get_parent().get_parent().get_parent().add_child(win)
		get_parent().get_parent().queue_free()
	
	
	#function to shoot bullets every once in a while
	if counter1 == 20:
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
	helper = randf()
	
	if helper <= 0.2:
		var bullet = blue_bullet_scene.instantiate()
		bullet.type = "Boss_Bullet"
		bullet.position = position
		bullet.bullet_direction = (position - player.position).normalized()
		get_parent().add_child(bullet)
		var bullet2 = blue_bullet_scene.instantiate()
		bullet2.type = "Boss_Bullet"
		bullet2.position = position
		bullet2.bullet_direction = (position + player.position).normalized()
		get_parent().add_child(bullet2)
	if helper > 0.2:
		if helper <= 0.55:
			var bullet = yellow_bullet_scene.instantiate()
			bullet.type = "Boss_Bullet"
			bullet.position = position
			bullet.bullet_direction = (position - player.position).normalized()
			get_parent().add_child(bullet)
			var bullet2 = yellow_bullet_scene.instantiate()
			bullet2.type = "Boss_Bullet"
			bullet2.position = position
			bullet2.bullet_direction = (position + player.position).normalized()
			get_parent().add_child(bullet2)
	if helper > 0.55:
		if helper <= 0.6:
			var bullet = red_bullet_scene.instantiate()
			bullet.type = "Boss_Bullet"
			bullet.position = position
			bullet.bullet_direction = (position - player.position).normalized()
			get_parent().add_child(bullet)
	if helper > 0.6:
		if helper <= 0.8:
			var bullet = purple_bullet_scene.instantiate()
			bullet.type = "Boss_Bullet"
			bullet.position = position
			bullet.bullet_direction = (position - player.position).normalized()
			get_parent().add_child(bullet)
			var bullet2 = purple_bullet_scene.instantiate()
			bullet2.type = "Boss_Bullet"
			bullet2.position = position
			bullet2.bullet_direction = (position + player.position).normalized()
			get_parent().add_child(bullet2)
	if helper > 0.8:
		var bullet = green_bullet_scene.instantiate()
		bullet.type = "Boss_Bullet"
		bullet.position = position
		bullet.bullet_direction = (position - player.position).normalized()
		get_parent().add_child(bullet)
		var bullet2 = green_bullet_scene.instantiate()
		bullet2.type = "Boss_Bullet"
		bullet2.position = position
		bullet2.bullet_direction = (position + player.position).normalized()
		get_parent().add_child(bullet2)




func _on_area_2d_body_entered(body):
	#if body entered, and body is the player, set attack to true
	if body.name == "Player":
		attack = true



#if player exits, set attack to false
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		attack = false
