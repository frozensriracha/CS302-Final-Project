extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var map = get_node("SniperRoom")
	map.rotation_degrees += 90


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
