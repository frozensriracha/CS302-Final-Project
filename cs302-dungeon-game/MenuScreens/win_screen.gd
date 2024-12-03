extends Node2D
@onready var main_menu_scene = load("res://MenuScreens/main_menu.tscn")

var count: int = 1

func _process(delta):
	count = count + 1
	
	if count > 250:
		var start_game = main_menu_scene.instantiate()
		print("Scene instantiated:", start_game)
		get_parent().add_child(start_game)
		queue_free()
