extends Area2D


# Called when the node enters the scene tree for the first time.
func _on_body_entered(body):
	print('exiting from Entrance door 3...')
	print(body)
	print(' ')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass