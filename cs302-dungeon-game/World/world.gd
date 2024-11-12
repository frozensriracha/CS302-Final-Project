extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var map_center = $MapCenter
	var map = get_node("SniperRoom")
	map_center.position = Vector2(540, 960)
	map_center.pivot_offset = Vector2(0, 0)
	map_center.rotation_degrees += 90


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
