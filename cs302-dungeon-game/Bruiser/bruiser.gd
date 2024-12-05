extends CharacterBody2D
@onready var player = $"../Player"
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var sprite_animation = get_node("AnimatedSprite2D")
@onready var half_heart_scene = preload("res://Consumables/half_heart.tscn")

var speed = 2
var counter = 0
var attack = false
var health = 15
var random
var temporary
var keep_position




func _physics_process(delta):
	
	#counter to delay some processes in code (such as taking away health from player)
	counter += counter + delta
	
	
	if health == 0:
		sprite_animation.play("Death")
		
		#wait for some time to let the animation above play out
		await get_tree().create_timer(0.50).timeout
		
		#randomly generate heart or half-heart at death of bruiser, then queue_free()
		random = randf()
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
		
	#if attack true, take health from the player
	if attack == true:
		position = keep_position
		sprite_animation.play("Attack")
		if counter > 10000000:
			
			
			player.player_health = player.player_health - 1
			counter = 0
		
		
	
	
	#Continually update position of bruiser towards player, flip orientation so it always faces player
	temporary = position.x
	position += ((player.position - position).normalized()) * (speed)
	if temporary > position.x:
		sprite_animation.flip_h = true
	else:
		sprite_animation.flip_h = false
		
	move_and_slide()




#if body entered, set attack to true
func _on_bruiser_area_body_entered(body):
	keep_position = position
	if body.name == "Player":
		print("ENTERED")
		attack = true


#if player exits, set attack to false
func _on_bruiser_area_body_exited(body):
	if body.name == "Player":
		keep_position = position
		attack = false
		sprite_animation.play("Idle")
