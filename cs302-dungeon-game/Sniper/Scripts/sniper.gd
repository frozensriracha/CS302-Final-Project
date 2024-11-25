extends CharacterBody2D
@onready var player = $"../Player"
@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var laser = get_node("Sniper_Shape").get_node("Sight")
#var direction
#var target_angle
var counter: int = 1
var counter_speed: float = 1.0
var helper
var health = 40
var random

func _process(delta):
	counter += counter_speed + delta
	if health == 0:
		random = randf()
		print(random)
		if random > 0.8:
			var heart = heart_scene.instantiate()
			heart.position = position
			get_parent().add_child(heart)
		queue_free()
	#rotation = player.position.angle()
	#direction = player.position - position  # Calculate the direction vector
	#target_angle = direction.angle()  # Get the angle towards the player
	#rotation = target_angle
	
	if counter == 50:
		laser.visible = false
		shoot()
		counter = 0


func shoot():
	helper = randf()
	if helper < 0.5:
	#var bullet = bullet_scene.instantiate()
	#bullet.position = position
	#bullet.bullet_direction = (position - player.position)
	#get_parent().add_child(bullet)
		laser.visible = true
		var bullet = bullet_scene.instantiate()
		bullet.type = "Sniper_Bullet"
		bullet.position = position
	
		bullet.bullet_direction = (position - player.position).normalized()
		get_parent().add_child(bullet)
	
