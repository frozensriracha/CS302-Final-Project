extends Node2D
@onready var main_menu_scene = load("res://MenuScreens/main_menu.tscn")
var counter: int = 1


#This code is the game_over screen if player dies, and it instantiates the main menu after 300 iterations
func _process(delta):
	counter = counter + 1
	print(counter)
	if counter > 300:
		
		var start_game = main_menu_scene.instantiate()
		print("Scene instantiated:", start_game)
		get_parent().add_child(start_game)
		queue_free()
