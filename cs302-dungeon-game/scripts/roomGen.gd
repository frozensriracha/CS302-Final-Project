class_name RoomGen

var rooms = Rooms.new() # import room types
var roomInstances: Array[Rooms.room] # Array that holds the data for each room in the dungeon
var rng = RandomNumberGenerator.new()

var generationMatrix: Array[int] # 2d array to check for overlap (Use coord-to-ID conversions)
var numCols # Used to track the number of columns there are in array2D

# Changes the cell's expression from the ID format to coordinates
func toCoords(ID:int):
	return Vector2(ID/numCols, ID%numCols);

# Changes the cell's expression from coordinates to the ID format
func toID(coords:Vector2):
	return (coords[0]*numCols + coords[1])


# DEBUG - check if the script was initialized
func checkInit():
	print("RoomGen initialized successfully")
	pass

# DEBUG - prints the generationMatrix
func printGenMatrix():
	print("Generation Matrix:")
	var line: String
	for i in range(generationMatrix.size()):
		line += str(generationMatrix[i])
		line += " "
		if (i+1)%numCols == 0:
			print(line)
			line = ""


# Sets the destination of door1 to door2 and vice-versa
func connectDoors(room1:int, door1:int, room2:int, door2:int):
	roomInstances[room1].doorDests[door1] = Vector2(room2, door2) # Door1 -> Door2
	roomInstances[room2].doorDests[door2] = Vector2(room1, door1) # Door2 -> Door1

# Returns the position of a door relative to it's parent room
func getDoorPosLocal(roomID, doorID):
	var numEnterances = roomInstances[roomID].enterances.size()
	if doorID <= numEnterances:
		return roomInstances[roomID].enterances[doorID]
	else:
		return roomInstances[roomID].exits[doorID- numEnterances]

# Outputs a door's coordinates and rotation relative to the map
func getDoorPosGlobal(roomID:int, doorID:int):
	# Get room and door positions
	var roomPos:Vector3 = roomInstances[roomID].position
	var doorPos:Vector3 = getDoorPosLocal(roomID, doorID)
	
	# Rotation calculation is the same regardless of room rotation
	var doorGlobalRotation:int = int(roomPos[2]+doorPos[2])%4
	
	if roomPos[2] == 0:
		return Vector3(roomPos[0]+doorPos[0], roomPos[1]+doorPos[1], doorGlobalRotation)
	elif roomPos[2] == 1:
		return Vector3(roomPos[0]-doorPos[1], roomPos[1]+doorPos[0], doorGlobalRotation)
	elif roomPos[2] == 1:
		return Vector3(roomPos[0]-doorPos[0], roomPos[1]-doorPos[1], doorGlobalRotation)
	elif roomPos[3] == 1:
		return Vector3(roomPos[0]+doorPos[1], roomPos[1]-doorPos[0], doorGlobalRotation)


# Generates the specified type of room off of the specified room and door
func generateRoom(roomName:String, offOfRoomID:int, offOfDoorID:int, abortOnConflict:bool = true):
	var newRoom:Rooms.room = rooms.roomsDict.get(roomName)
	# Get the global positon of the door we want to generate a room off of
	var offOfDoorPos = getDoorPosGlobal(offOfRoomID, offOfDoorID)
	
	# Choose a random enterance door from the new room to connect to the offOfDoor
	var connectingDoorID:int = rng.randi_range(0,newRoom.enterances.size())
	var connectingDoorPosRel:Vector3 = newRoom.enterances[connectingDoorID]
	
	# Calculate the position of the new door
	var connectingDoorPosGlobal:Vector3 = offOfDoorPos
	connectingDoorPosGlobal[2] = int(connectingDoorPosGlobal[2] + 4) % 2 # 180deg rotation
	if offOfDoorPos[2] == 0:   # offOf door facing North - connecting door is one cell up
		connectingDoorPosGlobal[0] -= 1
	elif offOfDoorPos[2] == 1: # offOf door facing East - connecting door is one cell right
		connectingDoorPosGlobal[1] += 1
	elif offOfDoorPos[2] == 2: # offOf door facing South - connecting door is one cell down
		connectingDoorPosGlobal[0] += 1
	elif offOfDoorPos[2] == 3: # offOf door facing West - connecting door is one cell left
		connectingDoorPosGlobal[1] -= 1
	
	# Calculate rotation of the new room
	newRoom.position[2] = int(connectingDoorPosGlobal[2] - connectingDoorPosRel[2]) % 4
	
	# Get the dimensions of the room relative to the map
	var newRoomSizeGlobal:Vector2
	if newRoom.position[2] == 0 or newRoom.position[2] == 2:
		newRoomSizeGlobal = newRoom.size
	else: # Size x and y are flipped if room is "sideways"
		newRoomSizeGlobal = Vector2(newRoom.size.y, newRoom.size.x)
	
	# Calculate position/origin of the new room AND the top-leftmost cell in that room
	var topLeftmostCoord:Vector2
	if newRoom.position[2] == 0:
		newRoom.position[0] = connectingDoorPosGlobal[0] - connectingDoorPosRel[0]
		newRoom.position[1] = connectingDoorPosGlobal[1] - connectingDoorPosRel[1]
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1])
	elif newRoom.position[2] == 1:
		newRoom.position[0] = connectingDoorPosGlobal[0] + connectingDoorPosRel[1]
		newRoom.position[1] = connectingDoorPosGlobal[1] - connectingDoorPosRel[0]
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0], newRoom.position[0])
	elif newRoom.position[2] == 2:
		newRoom.position[0] = connectingDoorPosGlobal[0] - connectingDoorPosRel[0]
		newRoom.position[1] = connectingDoorPosGlobal[1] - connectingDoorPosRel[1]
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0], newRoom.position[1]-newRoomSizeGlobal[1])
	elif newRoom.position[2] == 3:
		newRoom.position[0] = connectingDoorPosGlobal[0] - connectingDoorPosRel[1]
		newRoom.position[1] = connectingDoorPosGlobal[1] + connectingDoorPosRel[0]
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1]-newRoomSizeGlobal[1])
	
	# Check if new room conflicts/overlaps with any other rooms in the generationMatrix
	var roomConflicts:bool = false
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			if generationMatrix[toID(coords)] != -1: roomConflicts = true
	if roomConflicts and abortOnConflict == true: return false
	
	# Add the room to the roomInstances array
	roomInstances.append(newRoom)
	
	#Mark the area taken up by the new room in the generationMatrix
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			generationMatrix[toID(coords)] = roomInstances.size()-1
	return true

# Generates a room without connecting doors - used for generating the starting room
func forceGenRoom(roomName:String, position:Vector3):
	var newRoom:Rooms.room = rooms.roomsDict.get(roomName)
	
	# Set position
	newRoom.position = position
	
	# Get the dimensions of the room relative to the map
	var newRoomSizeGlobal:Vector2
	if newRoom.position[2] == 0 or newRoom.position[2] == 2:
		newRoomSizeGlobal = newRoom.size
	else: # Size x and y are flipped if room is "sideways"
		newRoomSizeGlobal = Vector2(newRoom.size.y, newRoom.size.x)
	
	# Calculate position/origin of the new room AND the top-leftmost cell in that room
	var topLeftmostCoord:Vector2
	if newRoom.position[2] == 0:
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1])
	elif newRoom.position[2] == 1:
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0], newRoom.position[0])
	elif newRoom.position[2] == 2:
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0], newRoom.position[1]-newRoomSizeGlobal[1])
	elif newRoom.position[2] == 3:
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1]-newRoomSizeGlobal[1])
	
	# Add the room to the roomInstances array
	roomInstances.append(newRoom)
	
	#Mark the area taken up by the new room in the generationMatrix
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			generationMatrix[toID(coords)] = roomInstances.size()-1
	return true

# Generates a demo dungeon with four connected rooms to test other functions
func generateDemoDungeon():
	roomInstances.append(rooms.roomsDict.get("sniperRoom")) #0
	roomInstances.append(rooms.roomsDict.get("normalHall")) #1
	connectDoors(0,4, 1,1) # 0,4 -> 1,1
	
	roomInstances.append(rooms.roomsDict.get("globRoom")) #2
	connectDoors(1,3, 2,0) # 1,3 -> 2,0
	
	roomInstances.append(rooms.roomsDict.get("bruiserRoom")) #3
	connectDoors(1,5, 3,0) # 1,5 -> 3,0
	
	return roomInstances

func generateDungeon(mainChainLength:int):
	# Init 50x50 matrix
	for i in range(25*25):
		generationMatrix.append(-1)
	#generationMatrix.resize(50 * 50, 0)
	numCols = 25
	
	# Starting room
	print(forceGenRoom("globRoom", Vector3(0,0,0)))
	generateRoom("SniperRoom", 0, 0, false)
	printGenMatrix()
	#for i in range(mainChainLength):
		#rooms.roomsDict[2]
		
	# Ending room
	roomInstances.append(rooms.roomsDict.get("bossRoom"))
	
	return roomInstances

func _init():
	pass
