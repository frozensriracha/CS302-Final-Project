extends CharacterBody2D

#const bulletPath = preload('res://Bullet/player_bullet1.tscn')
const max_speed = 10
#get_global_mouse_position() just gets the current position of the mouse. "global_position" gets the
#position of the CharacterBody2D object, which is the player
var weapon_direction = get_global_mouse_position() - position
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
@onready var scene = get_parent()
@onready var sprite_animation = get_node("Sprite2D")
@onready var game_over_scene = preload("res://Bullet2/bullet_for_player.tscn")
@onready var game_over = preload("res://MenuScreens/game_over.tscn")

func _physics_process(delta):
	move()
	
	#counter to use for later processes
	counter += counter + delta
	
	#if player picks up hearts, it could theoretically get more than a hundred health, so this elminates this possibility
	if player_health  > 100:
		player_health = 100

	#This was a bug, but this fixed it
	if player_health < 1:
		player_health = 0
		
	#instantiate game_over scene if player dies
	if player_health == 0:
		var gameOver = game_over.instantiate()
		get_parent().get_parent().get_parent().add_child(gameOver)
		get_parent().get_parent().queue_free()
		
		#call "Shoot" if counter is 10, and left_click mouse is clicked. The point of the counter is so that the player cannot rapid fire
	if Input.is_action_just_pressed("ShootBullet"):
		if counter > 10:
			shoot()
			#reset counter
			counter = 0


#Parts of the movement code was taken from DevWorm's "How to Create SMOOTH Player Movement in Godot 4.0" Youtube video.
func get_XandY():
	#x position is just dependent on right and left subtractive movements. Same with y position, just up and down
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))

	return input.normalized() #if this wasn't set to normalized, moving in the diagonal direction would be faster (Pythagorean Theorem)

func move():
	#call input to get input
	input = get_XandY()
	
	#if input is zero, still get weapon direction, but make velocity 0
	if input == Vector2.ZERO:
			velocity = Vector2.ZERO
			weapon_direction = get_global_mouse_position() - position
			
	#otherwise, use input to set velocity
	else:
		#helper is used to orient the player in the direction of x-movement
		var helper = velocity.x
		velocity += (input * max_speed)
	
		
		weapon_direction = get_global_mouse_position() - position
		if helper > velocity.x:
			sprite_animation.flip_h = true
		else:
			sprite_animation.flip_h = false
		
	#move_and_slide() is godot's way of handling physic for us
	move_and_slide()

#instantiate bullet if shoot() is called, make it shoot in direction of weapon (Where mouse is)
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.type = "Player_Bullet"
	bullet.position = position
	
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)
	
