extends Node2D
@onready var main_menu_scene = load("res://MenuScreens/main_menu.tscn")

var counter: int = 1


# Called when the node enters the scene tree for the first time.
func _process(delta):
	counter = counter + 1
	print(counter)
	if counter > 300:
		
		var start_game = main_menu_scene.instantiate()
		print("Scene instantiated:", start_game)
		get_parent().add_child(start_game)
		queue_free()
