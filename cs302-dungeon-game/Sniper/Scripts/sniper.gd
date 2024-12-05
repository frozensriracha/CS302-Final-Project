extends CharacterBody2D
#have sprites, and bullet ready to go
@onready var player = $"../Player"
@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var laser = get_node("Sight")
@onready var sprite_animation = get_node("AnimatedSprite2D")
@onready var gun = get_node("AnimatedSprite2D").get_node("Sprite2D")
@onready var half_heart_scene = preload("res://Consumables/half_heart.tscn")

#variables
var counter: int = 1
var counter_speed: float = 1.0
var helper
var helper2
var health = 40
var random
var checkHit

#process function continually called
func _process(delta):
	
	#make player always idle
	sprite_animation.play("Idle")
	
	#Flip sniper to always face towards player
	if player.position.x < position.x:
		sprite_animation.flip_h = true
		gun.flip_h = true
	else:
		sprite_animation.flip_h = false
		gun.flip_h = false
	
	
	#counter so that the sniper does not shoot every second
	counter += counter_speed + delta
	
	#if health 0, randomly generate heart or half heart, and queue_free()
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
	
	#shoot if counter = 100, reset counter
	if counter == 100:
		laser.visible = false
		shoot()
		counter = 0
	

func shoot():
	
	#randomly shoot, and instantiate bullet when sniper shoots.
	helper = randf()
	if helper < 0.2:
	
		laser.visible = true
		var bullet = bullet_scene.instantiate()
		bullet.type = "Sniper_Bullet"
		bullet.position = position
	
		bullet.bullet_direction = (position - player.position).normalized()
		get_parent().add_child(bullet)
	
