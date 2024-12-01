extends Area2D

var type = null

func _on_body_entered(body):
	if body.name == "Player": # Only players should trigger doors
		# Area2D -> ColorRect -> Enterences/Exits "Folder" -> Room -> Game
		# 5 Jumps
		var masterNode: Node = self.get_parent().get_parent().get_parent().get_parent()
		masterNode.call("doorEntered", self.name.to_int())
