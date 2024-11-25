extends Node2D

# import scripts
var roomGen = RoomGen.new()
var roomTypes = Rooms.new()

# Generate dungeon
var dungeon: Array[Rooms.room] = roomGen.generateDemoDungeon()

var currentRoomName = dungeon[0].type # Should be the name of attached room at start
var currentRoomID: int = 0            # The current room's index in the room instances vec

# Deloads the current room, loads the desired room, and places the player in the correct place
func switchTo(roomID:int, doorID:int):
	# do nothing if already in desired room
	if currentRoomID == roomID: 
		print("already in room " + str(roomID))
		return 
	
	
	# Get room instance
	var roomData = dungeon[roomID]
	var roomName = roomData.type

	# Remove all child nodes of the roomManager
	# (should be only one, but you can never be too safe!)
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()
		print("Deloaded " + n.name)
	
	# load and create a new instance of the desired room
	var scene = load("res://Rooms/" + roomName + "/" + roomName + ".tscn")
	var instance = scene.instantiate()
	instance.name = roomName
	self.add_child(instance)
	print("Loaded " + roomName)
	
	# Deload any unlinked doors
	
	# Place the player at the correct door
	await get_tree().create_timer(1.0).timeout
	var player: Node2D = self.find_child("Player")
	if player == null: print("Null player")
	else: print(player.position)
	
	# update currentRoom
	currentRoomName = roomName
	currentRoomID = roomID
	
	return

# Gets the door's destination and calls switchTo if the destination != null
func doorEntered(doorID: int):
	var exit: Vector2 = dungeon[currentRoomID].doorDests[doorID]
	
	print("Current: " + str(currentRoomID) + "," + str(doorID))
	print("Next: " + str(exit[0]) + "," + str(exit[1]))
	
	if exit == Vector2(0,0):
		print("Door does not have an exit")
	else:
		switchTo(exit[0], exit[1])
	
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	switchTo(0,0)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# triggers for room switching can be changed
	if Input.is_action_just_pressed("switchRoom1"): switchTo(0,0)
	if Input.is_action_just_pressed("switchRoom2"): switchTo(1,0)
	pass
