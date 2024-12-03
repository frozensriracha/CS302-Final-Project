extends Node2D
@onready var sprite_animation = get_node("Sprite2D")
@onready var game_scene = preload("res://game.tscn")
var hovering

func _process(delta):
	sprite_animation.play("Idle")
	if hovering == true:
		sprite_animation.play("Hover_Animation")
	if Input.is_action_just_pressed("ShootBullet"):
		var start_game = game_scene.instantiate()
		get_parent().add_child(start_game)
		queue_free()
		#visible = false

func _on_area_2d_mouse_entered():
	hovering = true
	#if Input.is_action_pressed("ShootBullet"):
		#print("entering game...")

func _on_area_2d_mouse_exited():
	hovering = false
	sprite_animation.play("Idle")
