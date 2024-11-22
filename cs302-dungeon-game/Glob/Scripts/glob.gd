extends CharacterBody2D
@onready var player = $"../Player"

var speed = 1
#var player_chase = false
var counter: int = 0


#func _ready():
	#var player = get_node("/root/GlobRoom/Player")

func _physics_process(delta):
	#counter += counter + delta
	#if player_chase:
		#if player.name == "Player":
	position += ((player.position - position).normalized()) * (speed)
	
	move_and_slide()




#func _on_area_2d_body_entered(body):
	#player = body
	#player_chase = true


#func _on_area_2d_body_exited(body):
	#player = body
	#player_chase = true
	
	
