extends CharacterBody2D
@onready var player = $"../Player"
@onready var heart_scene = preload("res://Consumables/heart.tscn")

var speed = 1
#var player_chase = false
var counter = 0
var attack = false
var health = 15
var random


#func _ready():
	#var player = get_node("/root/GlobRoom/Player")

func _physics_process(delta):
	counter += counter + delta
	#print(player.player_health)
	
	if health == 0:
		random = randf()
		if random > 0.8:
			var heart = heart_scene.instantiate()
			heart.position = position
			get_parent().add_child(heart)
		queue_free()
	
	if attack == true:
		if counter > 10000:
			#print("HERE2")
			player.player_health = player.player_health - 1 
			counter = 0
		#if player.name == "Player":
		
	position += ((player.position - position).normalized()) * (speed)
	randf
	move_and_slide()




func _on_area_2d_body_entered(body):
	if body.name == "Player":
		#print("ENTERED")
		#player.health = player.health - 1
		attack = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		#print("EXITED")
		attack = false
	
	
