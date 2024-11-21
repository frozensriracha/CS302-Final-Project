extends Area2D

func _on_body_entered(body):
	# Area2D -> ColorRect -> Door Node2D -> Enterences/Exits Node2D -> Room -> Game
	# 5 Jumps
	var masterNode: Node = self.get_parent().get_parent().get_parent().get_parent().get_parent()
	print("Area")
	masterNode.call("doorEntered", self.name)
	#print('exiting from Exit Door 1...')
	#print(body)
	#print(' ')
