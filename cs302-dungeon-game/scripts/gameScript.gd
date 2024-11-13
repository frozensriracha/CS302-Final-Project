extends Node2D

# import scripts
var roomGen = RoomGen.new()

# global variables for script
var currentRoomName = "SniperRoom" # Should be the name of attached room at start

func switchTo(roomName):
	# do nothing if already in desired room
	if currentRoomName == roomName: 
		print("already in " + roomName)
		return 

	# delete current room
	var currNode = get_node(currentRoomName)
	self.remove_child(currNode)
	
	# load and create a new instance of the desired room
	var scene = load("res://Rooms/" + roomName + "/" + roomName + ".tscn")
	var instance = scene.instantiate()
	instance.name = roomName
	self.add_child(instance)
	
	# DEBUG - print all children of the roomManager and room switched into
	#print("switched to " + roomName)
	#for i in range(self.get_child_count(false)):
		#print(self.get_children()[i].name)
	
	# update currentRoom
	currentRoomName = roomName
	
	pass;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roomGen.checkInit()
	roomGen.checkRoomArray()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# triggers for room switching cna be changed
	if Input.is_action_just_pressed("switchRoom1"): switchTo("SniperRoom")
	if Input.is_action_just_pressed("switchRoom2"): switchTo("GlobRoom")
	pass
