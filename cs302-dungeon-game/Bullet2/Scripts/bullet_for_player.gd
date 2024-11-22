extends Area2D

var speed = 700
var bullet_direction
var type = null

func _process(delta):
	position -= bullet_direction * speed * delta
