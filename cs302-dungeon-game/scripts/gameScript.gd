extends Node2D

# import scripts
var roomGen = RoomGen.new()
var roomTypes = Rooms.new()

# Generate dungeon
var dungeon: Array[Rooms.room] = roomGen.generateDungeon(10, [.75, .12, .10, .3])
var currentRoomName = dungeon[0].type # Should be the name of attached room at start
var currentRoomID: int = 0            # The current room's index in the room instances vec
var switchToLockout:bool = false      # Doesn't allow player to switch rooms when true
var enemyCount: int = 0
var roomLoaded: bool = true

# Deloads the current room, loads the desired room, and places the player in the correct place
func switchTo(roomID:int, doorID:int):
	# do nothing if lockout is enabled
	if switchToLockout == true:
		print("Locked!")
		switchToLockout = false
		return
	switchToLockout = true # Enable lockout to disable infinite switching between doors
	
	# do nothing if trying to access an out-of-index room
	if roomID >= dungeon.size():
		print("Out-of-index error!")
		return
	
	roomLoaded = false
	
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
	
	# Get new room's number of enterances and exits
	var numEnterences = roomData.enterances.size()
	var numExits = roomData.exits.size()
	
	# Deload any unlinked doors
	for i in range(roomData.doorDests.size()): # For every door...
		# Get the door's ColorRect
		var doorToHide:ColorRect
		if i < numEnterences: doorToHide = self.get_child(0).get_node("Enterances/" + str(i))
		else: doorToHide = self.get_child(0).get_node("Exits/" + str(i))
		
		prints(str(i), str(roomData.doorDests[i]))
		if roomData.doorDests[i] == Vector2(-1,-1): # If door doesn't have a connection...
			prints("Hiding door", str(i), str(doorToHide))
			doorToHide.queue_free()
	
	
	# Deload all enemies if the room is defeated
	if dungeon[roomID].defeated == true:
		print("Removing enemies...")
		var enemyArray:Array[CharacterBody2D]
		enemyArray.append_array(self.get_child(0).find_children("Glob*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Sniper*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Bruiser*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Boss*", "", false))
		
		for enemy in enemyArray:
			enemy.queue_free()
	
	# Place the player at the correct door
	var player:Node2D = self.get_child(0).get_node("Player")
	var door:ColorRect
	if doorID < numEnterences: door = self.get_child(0).get_node("Enterances/" + str(doorID))
	else: door = self.get_child(0).get_node("Exits/" + str(doorID))
	player.position = Vector2(door.position)
	
	# Transfer player health
	player.player_health = oldHealth
	
	# update currentRoom
	currentRoomName = roomName
	currentRoomID = roomID
	
	print("Switched to RoomID " + str(roomID))
	roomLoaded = true
	
	return

# Gets the door's destination and calls switchTo if the destination != null and defeated = true
func doorEntered(doorID: int):
	var exit: Vector2 = dungeon[currentRoomID].doorDests[doorID]
	
	if exit == Vector2(-1,-1):
		print("Door does not have an exit")
	elif dungeon[currentRoomID].defeated == true:
		switchTo(exit[0], exit[1])
	
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#switchTo(0,0)
	switchToLockout = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		var enemyArray:Array[CharacterBody2D]
		enemyArray.append_array(self.get_child(0).find_children("Glob*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Sniper*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Bruiser*", "", false))
		enemyArray.append_array(self.get_child(0).find_children("Boss*", "", false))
		
		for enemy in enemyArray:
			enemy.queue_free()
	
	if Input.is_action_just_pressed("debug2"):
		roomGen.printGenMatrix()
		print(dungeon.size())
		print(currentRoomID)
	
	# Check if room is defeated
	if roomLoaded and self.get_child_count() != 0:
		var numEnemies:int
		numEnemies += self.get_child(0).find_children("Glob*", "", false).size()
		numEnemies += self.get_child(0).find_children("Sniper*", "", false).size()
		numEnemies += self.get_child(0).find_children("Bruiser*", "", false).size()
		numEnemies += self.get_child(0).find_children("Boss*", "", false).size()
		#print(numEnemies)
		if numEnemies == 0 and dungeon[currentRoomID].defeated == false:
			print("Room defeated")
			dungeon[currentRoomID].defeated = true
			switchToLockout = false
		
		
	
	
	pass
