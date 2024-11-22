extends Node2D

# import scripts
var roomGen = RoomGen.new()
var roomTypes = Rooms.new()

# global variables for script
var currentRoomName = "SniperRoom" # Should be the name of attached room at start
var currentRoomID = 0 # The current room's index in the room instances vec

func switchTo(roomID):	
	# do nothing if already in desired room
	if currentRoomID == roomID: 
		print("already in room " + roomID)
		return 
	
	
	# Get room instance
	#var roomData = roomInstances[roomID]
	#var roomName = roomData.type
	var roomName = "TEMP"

	# delete current room
	var currNode = get_node(currentRoomName)
	self.remove_child(currNode)
	
	# load and create a new instance of the desired room
	var scene = load("res://Rooms/" + roomName + "/" + roomName + ".tscn")
	var instance = scene.instantiate()
	instance.name = roomName
	self.add_child(instance)
	
	# Deload any unlinked doors
	
	# Update the health of enemies
	
	# Place the player at the correct door
	
	# DEBUG - print all children of the roomManager and room switched into
	#print("switched to " + roomName)
	#for i in range(self.get_child_count(false)):
		#print(self.get_children()[i].name)
	
	# update currentRoom
	currentRoomName = roomName
	currentRoomID = 5
	
	pass;

func doorEntered(name):
	print("Door " + name + " entered (message sent by gameScript.gd)")
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roomGen.checkInit()
	print(roomTypes.roomsDict.get("globRoom").size)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# triggers for room switching cna be changed
	if Input.is_action_just_pressed("switchRoom1"): switchTo("SniperRoom")
	if Input.is_action_just_pressed("switchRoom2"): switchTo("GlobRoom")
	pass
