extends CharacterBody2D

var speed = 35
var player_chase = false
var player = null

#func _ready():
	#var player = get_node("/root/GlobRoom/Player")

func _physics_process(delta):
	if player_chase:
		if player.name == "Player":
			position += (player.position - position) / (speed)
	
	move_and_slide()




func _on_area_2d_body_entered(body):
	player = body
	player_chase = true


func _on_area_2d_body_exited(body):
	player = body
	player_chase = true
	
	
