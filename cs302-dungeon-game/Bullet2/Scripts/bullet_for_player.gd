extends Area2D
@onready var player = $"../Player"

var object
var speed = 700
var bullet_direction
var type = null
var attack = false

func _process(delta):
	position -= bullet_direction * speed * delta
	
	if type == "Sniper_Bullet":
		if object == player:
			if attack == true:
				player.player_health = player.player_health - 5
				attack = false
				queue_free()
	
	if type == "Player_Bullet":
		if object is CharacterBody2D:
			if attack == true:
				object.health = object.health - 5
				attack = false
				queue_free()
				

func _on_body_entered(body):
	object = body
	if object != player:
		attack = true
	if object is StaticBody2D:
		queue_free()
