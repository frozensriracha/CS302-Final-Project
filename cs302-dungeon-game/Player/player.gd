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
			#rotation = weapon_direction.angle()
	
	else:
		velocity += (input * max_speed)
		weapon_direction = get_global_mouse_position() - global_position
		#rotation = weapon_direction.angle()
		
	
	move_and_slide()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = position
	
	bullet.bullet_direction = (position - get_global_mouse_position()).normalized()
	get_parent().add_child(bullet)


#Function to determine if body enters, which will make damage occur
func _on_damage_detection_body_entered(body):
	entered_body = body
	print("Body entered")
	print(entered_body.name)
	if entered_body.name == "Glob":
		print("Took Damage from Glob")
		take_Glob_Damage = true
	

#Function to determine if body exits, which will make damage not occur
func _on_damage_detection_body_exited(body):
	print("Body Exited")
	exited_body = body
	if exited_body.name == "Glob":
		take_Glob_Damage = false


func _on_damage_detection_area_entered(area):
	bullet_body = area
	if bullet_body.type == "Sniper_Bullet":
		print("Bullet Hit!")
		bullet_body.queue_free()
