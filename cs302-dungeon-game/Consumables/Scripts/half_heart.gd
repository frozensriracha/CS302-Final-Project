extends Area2D
@onready var player = $"../Player"

#add 10 health to player if player enters it
func _on_body_entered(body):
	if body.name == "Player":
		player.player_health = player.player_health + 10
		queue_free()
