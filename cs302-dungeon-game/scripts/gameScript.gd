extends Node2D

# import scripts
var roomGen = RoomGen.new()
var roomTypes = Rooms.new()

# Generate dungeon
var dungeon: Array[Rooms.room] = roomGen.generateDungeon(10, [.75, .12, .10, .3])
var currentRoomName = dungeon[0].type # Should be the name of attached room at start
var currentRoomID: int = 0            # The current room's index in the room instances vec
var switchToLockout:bool = false      # Doesn't allow player to switch rooms when true

# Deloads the current room, loads the desired room, and places the player in the correct place
func switchTo(roomID:int, doorID:int):
	# do nothing if lockout is enabled
	if switchToLockout == true:
		print("Locked!")
		switchToLockout = false
		return
	switchToLockout = true # Enable lockout to disable infinite switching between doors
	
	# DEBUG - Print all doorDests
	print("All doorDests for roomID " + str(currentRoomID))
	for n in dungeon[currentRoomID].doorDests:
		print("  " + str(n))
	
	# Save current player health
	var oldHealth = self.get_child(0).get_node("Player").player_health
	
	# Get room instance
	var roomData = dungeon[roomID]
	var roomName = roomData.type

	# Remove all child nodes of the roomManager
	# (should be only one, but you can never be too safe!)
	for n in self.get_children():
		n.queue_free()
	
	# load and create a new instance of the desired room
	await get_tree().create_timer(0.01).timeout
	var scene = load("res://Rooms/" + roomName + "/" + roomName + ".tscn")
	var instance = scene.instantiate()
	instance.name = roomName
	self.add_child(instance)
	
	# Deload any unlinked doors
	
	# Deload all enemies if the room is defeated
	
	# Place the player at the correct door
	var player:Node2D = self.get_child(0).get_node("Player")
	
	var door:ColorRect = self.get_child(0).get_node("Enterances/" + str(doorID))
	if door == null: door = self.get_child(0).get_node("Exits/" + str(doorID))
	
	print("Player: ", player.position) 
	print("Door: ", door.position)
	
	player.position = Vector2(door.position) # BUG - player is placed at seemingly random position if room has ever been deloaded 
	
	# Transfer player health
	player.player_health = oldHealth
	
	# update currentRoom
	currentRoomName = roomName
	currentRoomID = roomID
	
	print("Switched to RoomID " + str(roomID))
	
	return

# Gets the door's destination and calls switchTo if the destination != null
func doorEntered(doorID: int):
	var exit: Vector2 = dungeon[currentRoomID].doorDests[doorID]
	
	print("Current: " + str(currentRoomID) + "," + str(doorID))
	print("Next: " + str(exit[0]) + "," + str(exit[1]))
	
	if exit == Vector2(-1,-1):
		print("Door does not have an exit")
	else:
		switchTo(exit[0], exit[1])
	
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#switchTo(0,0)
	switchToLockout = false
	print("Dungeon gen:")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		self.get_child(0).get_node("Player").position = Vector2(960, 540)
		switchToLockout = false
	if Input.is_action_just_pressed("debug2"):
		roomGen.printGenMatrix()
		print(currentRoomID)
	pass
