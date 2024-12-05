extends Area2D
@onready var player = $"../Player"

var object
var speed = 700
var bullet_direction
var type = null
var attack = false

#Generic bullet script for sniper and player
func _process(delta):
	position -= bullet_direction * speed * delta
	rotation = bullet_direction.angle()
	
	#if area2D's type is sniper_bullet, it cannot take health from sniper, but takes health from player
	if type == "Sniper_Bullet":
		if object == player:
			if attack == true:
				player.player_health = player.player_health - 5
				attack = false
				queue_free()
	
	#if area2D's type is player_bullet, it cannot take health from player, but takes health from any characterbody that is not the player
	if type == "Player_Bullet":
		if attack == true:
			if object != player:
				if object == null:
					pass
				else:
					object.health = object.health - 5
					attack = false
					queue_free()

	if type == "Boss_Bullet":
		if object == player:
			if attack == true:
				player.player_health = player.player_health - 5
				attack = false
				queue_free()

#function to figure out if bullet enters a body
func _on_body_entered(body):
	object = body
	if object != player:
		attack = true
	if object is StaticBody2D:
		queue_free()
