extends CharacterBody2D

#const bulletPath = preload('res://Bullet/player_bullet1.tscn')
const max_speed = 10
#get_global_mouse_position() just gets the current position of the mouse. "global_position" gets the
#position of the CharacterBody2D object, which is the player
var weapon_direction = get_global_mouse_position() - global_position
var input = Vector2.ZERO
var counter = 1

@onready var bullet_scene = preload("res://Bullet2/bullet_for_player.tscn")


func _physics_process(delta):
	move()
	counter += counter + delta
	if Input.is_action_just_pressed("ShootBullet"):
		if counter > 100000:
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
			rotation = weapon_direction.angle()
	
	else:
		velocity += (input * max_speed)
		weapon_direction = get_global_mouse_position() - global_position
		rotation = weapon_direction.angle()
		
	
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)



#func shoot():
	#var bullet = bulletPath.instance()
	
	#get_parent().add_child(bullet)
	#bullet.position = $Position2D.global_position
