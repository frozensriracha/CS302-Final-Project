extends CharacterBody2D

#const bulletPath = preload('res://Bullet/player_bullet1.tscn')
const max_speed = 10
#get_global_mouse_position() just gets the current position of the mouse. "global_position" gets the
#position of the CharacterBody2D object, which is the player
var weapon_direction = get_global_mouse_position() - global_position
var input = Vector2.ZERO
var counter = 1
var entered_body
var bullet_body
var exited_body
var take_Sniper_Damage = false
var take_Glob_Damage = false
var player_health = 100
var helper

@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")
#@onready var game_over = preload("res://Rooms/GameOver/game_over.tscn")
@onready var scene = get_parent()
@onready var sprite_animation = get_node("Sprite2D")

func _physics_process(delta):
	move()
	counter += counter + delta
	
	if player_health == 0:
		#scene.queue_free()
		#var end = game_over.instantiate()
		#get_parent().get_parent().add_child(end)
		
		#get_tree().paused = true
		scene.queue_free()
	
	if Input.is_action_just_pressed("ShootBullet"):
		if counter > 10:
			#take_Glob_damage()
			shoot()
			counter = 0

	
func get_XandY():
	#x position is just dependent on right and left subtractive movements. Same with y position, just up and down
	
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
		
	return input.normalized() #if this wasn't set to normalized, moving in the diagonal direction would be faster (Pythagorean Theorem)

func move():
	input = get_XandY()
	
	if input == Vector2.ZERO:
			velocity = Vector2.ZERO
			weapon_direction = get_global_mouse_position() - global_position
			#rotation = weapon_direction.angle()
	
	else:
		var helper = velocity.x
		velocity += (input * max_speed)
		weapon_direction = get_global_mouse_position() - global_position
		#rotation = weapon_direction.angle()
		if helper > velocity.x:
			sprite_animation.flip_h = true
		else:
			sprite_animation.flip_h = false
		
	
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.type = "Player_Bullet"
	bullet.position = position
	
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)
	
#func take_Glob_damage():
	#if take_Glob_Damage == true:
	#	player_health = player_health - 1
	#	print(player_health)

#func take_Sniper_damage():
	#player_health = player_health - 5
	#print(player_health)


#Function to determine if body enters, which will make damage occur
#func _on_damage_detection_body_entered(body):
	#entered_body = body
	#if entered_body.name == "Glob":
		#take_Glob_Damage = true
		#take_Glob_damage()
	

#Function to determine if body exits, which will make damage not occur
#func _on_damage_detection_body_exited(body):
	#exited_body = body
	#if exited_body.name == "Glob":
		#take_Glob_Damage = false


#func _on_damage_detection_area_entered(area):
	#bullet_body = area
	#if bullet_body.type == "Sniper_Bullet":
		#bullet_body.queue_free()
		#take_Sniper_damage()
