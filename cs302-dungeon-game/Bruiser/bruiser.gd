extends CharacterBody2D
@onready var player = $"../Player"
@onready var heart_scene = preload("res://Consumables/heart.tscn")
@onready var sprite_animation = get_node("AnimatedSprite2D")

var speed = 2
#var player_chase = false
var counter = 0
var attack = false
var health = 100
var random
var temporary
var keep_position


#func _ready():
	#var player = get_node("/root/GlobRoom/Player")

func _physics_process(delta):
	
	counter += counter + delta
	#print(player.player_health)
	
	if health == 0:
		sprite_animation.play("Death")
		#wait for some time to let the animation above play out
		await get_tree().create_timer(0.50).timeout
		random = randf()
		if random > 0.8:
			var heart = heart_scene.instantiate()
			heart.position = position
			get_parent().add_child(heart)
			
		queue_free()
		
	
	if attack == true:
		position = keep_position
		sprite_animation.play("Attack")
		if counter > 10000000:
			#print("HERE2")
			
			player.player_health = player.player_health - 1
			counter = 0
		#if player.name == "Player":
		
	
	
	
	temporary = position.x
	position += ((player.position - position).normalized()) * (speed)
	if temporary > position.x:
		sprite_animation.flip_h = true
	else:
		sprite_animation.flip_h = false
		
	move_and_slide()





func _on_bruiser_area_body_entered(body):
	keep_position = position
	if body.name == "Player":
		print("ENTERED")
		#player.health = player.health - 1
		attack = true



func _on_bruiser_area_body_exited(body):
	if body.name == "Player":
		keep_position = position
		#print("EXITED")
		attack = false
		sprite_animation.play("Idle")
