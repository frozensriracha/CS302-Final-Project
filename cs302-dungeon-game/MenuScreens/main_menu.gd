extends Node2D
@onready var sprite_animation = get_node("Sprite2D")
@onready var game_scene = preload("res://game.tscn")
var hovering

#Code for main menu
func _process(delta):
	#keep "NEW GAME" in idle orientation if not touched by mouse
	sprite_animation.play("Idle")
	#if hovering over "NEW GAME", set animation to "Hover_Animation"
	if hovering == true:
		sprite_animation.play("Hover_Animation")
		
	#If input (left mouse click) is pushed, load game!
	if Input.is_action_just_pressed("ShootBullet"):
		if hovering == true:
			var start_game = game_scene.instantiate()
			get_parent().add_child(start_game)
			queue_free()

#These two functions send signal if mouse is hovering over "NEW GAME" or ot
func _on_area_2d_mouse_entered():
	hovering = true


func _on_area_2d_mouse_exited():
	hovering = false
	sprite_animation.play("Idle")
