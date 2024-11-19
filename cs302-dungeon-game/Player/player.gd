extends CharacterBody2D

const max_speed = 10
#get_global_mouse_position() just gets the current position of the mouse. "global_position" gets the
#position of the CharacterBody2D object, which is the player
var weapon_direction = get_global_mouse_position() - global_position
var input = Vector2.ZERO
var bullet = preload("res://Bullet/player_bullet1.tscn")
var bullet_speed = 100

func _physics_process(delta):
	move()
	
func _shoot():
	look_at(get_global_mouse_position())
	if Input.is_action_pressed("ShootBullet"):
		var bullet_instance = bullet.instance()
		bullet_instance.position = $BulletPoint.get_global_position()
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		
	
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
