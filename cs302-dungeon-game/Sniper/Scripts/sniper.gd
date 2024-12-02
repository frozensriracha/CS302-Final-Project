extends CharacterBody2D
@onready var player = $"../Player"
@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var laser = get_node("Sight")
@onready var sprite_animation = get_node("AnimatedSprite2D")
@onready var gun = get_node("AnimatedSprite2D").get_node("Sprite2D")
@onready var half_heart_scene = preload("res://Consumables/half_heart.tscn")

#var direction
#var target_angle
var counter: int = 1
var counter_speed: float = 1.0
var helper
var helper2
var health = 40
var random
var checkHit

func _process(delta):
	
	sprite_animation.play("Idle")
	if player.position.x < position.x:
		sprite_animation.flip_h = true
		gun.flip_h = true
	else:
		sprite_animation.flip_h = false
		gun.flip_h = false
	
	
	
	counter += counter_speed + delta
	if health == 0:
		random = randf()
		print(random)
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
	
