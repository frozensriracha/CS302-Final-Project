extends Area2D
@onready var player = $"../Player"


func _on_body_entered(body):
	if body.name == "Player":
		player.player_health = player.player_health + 10
		queue_free()
