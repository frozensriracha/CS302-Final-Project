extends CharacterBody2D
@onready var player = $"../Player"
@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
var direction
var target_angle
var counter: int = 1
var counter_speed: float = 1.0
var helper

func _process(delta):
	counter += counter_speed + delta
	#rotation = player.position.angle()
	direction = player.position - position  # Calculate the direction vector
	target_angle = direction.angle()  # Get the angle towards the player
	rotation = target_angle
	
	if counter == 50:
		shoot()
		counter = 0


func shoot():
	helper = randf()
	if helper < 0.5:
	#var bullet = bullet_scene.instantiate()
	#bullet.position = position
	#bullet.bullet_direction = (position - player.position)
	#get_parent().add_child(bullet)
		var bullet = bullet_scene.instantiate()
		bullet.type = "Sniper_Bullet"
		bullet.position = position
	
		bullet.bullet_direction = (position - player.position).normalized()
		get_parent().add_child(bullet)
	
