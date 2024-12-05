extends Area2D
@onready var player = $"../Player"

var object
var speed = 500
var bullet_direction
var type = null
var attack = false

#This is the general script for the boss bullets. This script is used for every bullet EXCEPT the red one (Since it always tracks the player)

#make boss bullets (all but the red one) move towards the player upon intial shoot
func _process(delta):
	position -= bullet_direction * speed * delta
	rotation = bullet_direction.angle()
	

#take away health if it enters player
	if type == "Boss_Bullet":
		if object == player:
			if attack == true:
				player.player_health = player.player_health - 5
				attack = false
				queue_free()

#this function sends a signal if the bullet enters the player
func _on_body_entered(body):
	object = body
	if object != player:
		attack = true
	if object is StaticBody2D:
		queue_free()
