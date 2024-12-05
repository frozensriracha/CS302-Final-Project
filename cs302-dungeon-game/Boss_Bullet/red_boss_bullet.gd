extends Area2D
@onready var player = $"../Player"

var object
var speed = 200
var speed2 = 10
var bullet_direction
var type = null
var attack = false
var curve = true

#This code is IDENTICAL to the other bullet scenes, however, this one continually tracks and follows the player, since its the red bullet
func _process(delta):
	position -= bullet_direction * speed * delta
	rotation = bullet_direction.angle()
	
	#this is the code to always track the position of the player!
	position += (player.position - position).normalized() * speed2
	
#take away health if bullet enters player
	if type == "Boss_Bullet":
		if object == player:
			if attack == true:
				player.player_health = player.player_health - 5
				attack = false
				queue_free()

#functions to send signal if it hits player
func _on_body_entered(body):
	object = body
	if object != player:
		attack = true
	if object is StaticBody2D:
		queue_free()


func _on_area_entered(area):
	if area.type == "Player_Bullet":
		queue_free()
