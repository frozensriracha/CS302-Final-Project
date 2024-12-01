class_name RoomGen

var rooms = Rooms.new() # import room types
var roomInstances: Array[Rooms.room] # Array that holds the data for each room in the dungeon
var rng = RandomNumberGenerator.new()

var generationMatrix: Array[int] # 2d array to check for overlap (Use coord-to-ID conversions)
var numCols:int # Used to set and track the dimensions of the 2d array
var numRows:int # Used to set and track the dimensions of the 2d array

# Changes the cell's expression from the ID format to coordinates
func toCoords(ID:int):
	return Vector2(ID/numCols, ID%numCols);

# Changes the cell's expression from coordinates to the ID format
func toID(coords:Vector2):
	return (coords[1]*numCols + coords[0])


# DEBUG - check if the script was initialized
func checkInit():
	print("RoomGen initialized successfully")
	pass

# DEBUG - prints the generationMatrix
func printGenMatrix():
	print("Generation Matrix:")
	var line: String
	
	line += "    "
	for i in range(numCols):
		var numS: String = str(i)
		if numS.length() == 1: numS = " " + numS
		line += numS
		line += " "
	print(line)
	line = ""
	print("")
	
	for i in range(generationMatrix.size()):
		
		var cell: String = str(generationMatrix[i])
		if cell == "-1": cell = "--"
		if cell.length() == 1: cell = " " + cell
		line += str(cell)
		line += " "
		if (i+1)%numCols == 0:
			var lineNum:String = str(i/numCols)
			if lineNum.length() == 1: lineNum = " " + lineNum
			line = lineNum + "  " + line
			print(line)
			line = ""


# Sets the destination of door1 to door2 and vice-versa
func connectDoors(room1:int, door1:int, room2:int, door2:int):
	roomInstances[room1].doorDests[door1] = Vector2(room2, door2) # Door1 -> Door2
	roomInstances[room2].doorDests[door2] = Vector2(room1, door1) # Door2 -> Door1
	print("Connected doors (" + str(room1) + "," + str(door1) + ") to (" + str(room2) + "," + str(door2) + ")")

# Returns the position of a door relative to it's parent room
func getDoorPosLocal(roomID, doorID):
	var numEnterances = roomInstances[roomID].enterances.size()
	if doorID <= numEnterances-1:
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
	elif roomPos[2] == 2:
		return Vector3(roomPos[0]-doorPos[0], roomPos[1]-doorPos[1], doorGlobalRotation)
	elif roomPos[2] == 3:
		return Vector3(roomPos[0]+doorPos[1], roomPos[1]-doorPos[0], doorGlobalRotation)


# Generates the specified type of room off of the specified room and door
func generateRoom(roomName:String, doorID:int, offOfRoomID:int, offOfDoorID:int, abortOnConflict:bool = true):
	print("Generating " + roomName + "...") # DEBUG
	
	# Get room, throw error if roomName isn't a key in the roomsDict
	var newRoom:Rooms.room = rooms.roomsDict.get(roomName)
	if newRoom == null:
		print("Given roomType " + roomName + " is not a valid Roomtype (not found in roomsDict)")
		return false
	
	# Get the global positon of the door we want to generate a room off of
	var offOfDoorPos:Vector3 = getDoorPosGlobal(offOfRoomID, offOfDoorID)
	print("offOfDoorGlobal: " + str(offOfDoorPos)) # DEBUG

	
	# Choose a random enterance door from the new room to connect to the offOfDoor
	#var connectingDoorID:int = rng.randi_range(0,newRoom.enterances.size()-1)
	var connectingDoorID:int = doorID # DEBUG - change this back to the line above
	var connectingDoorPosRel:Vector3 = newRoom.enterances[connectingDoorID]
	print("connectingDoorPosRel: " + str(connectingDoorPosRel)) # DEBUG
	
	# Calculate the position of the new door
	var connectingDoorPosGlobal:Vector3 = offOfDoorPos
	connectingDoorPosGlobal[2] = int(connectingDoorPosGlobal[2] + 4) % 2 # 180deg rotation
	if offOfDoorPos[2] == 0:   # offOf door facing North - connecting door is one cell up
		connectingDoorPosGlobal[1] -= 1
	elif offOfDoorPos[2] == 1: # offOf door facing East - connecting door is one cell right
		connectingDoorPosGlobal[0] += 1
	elif offOfDoorPos[2] == 2: # offOf door facing South - connecting door is one cell down
		connectingDoorPosGlobal[1] += 1
	elif offOfDoorPos[2] == 3: # offOf door facing West - connecting door is one cell left
		connectingDoorPosGlobal[0] -= 1
	print("connectingDoorPosGlobal: " + str(connectingDoorPosGlobal)) # DEBUG
	
	# Calculate rotation of the new room
	newRoom.position[2] = abs(int(connectingDoorPosGlobal[2] - connectingDoorPosRel[2]) % 4)
	print("newRoom.position[2]: " + str(newRoom.position[2])) # DEBUG
	
	# Get the dimensions of the room relative to the map
	var newRoomSizeGlobal:Vector2
	if newRoom.position[2] == 0 or newRoom.position[2] == 2:
		newRoomSizeGlobal = newRoom.size
	else: # Size x and y are flipped if room is "sideways"
		newRoomSizeGlobal = Vector2(newRoom.size.y, newRoom.size.x)
	
	# Calculate position/origin of the new room AND the top-leftmost cell in that room
	var topLeftmostCoord:Vector2
	if newRoom.position[2] == 0: # Good by logic - inverse of 2
		newRoom.position[0] = connectingDoorPosGlobal[0] - connectingDoorPosRel[0]
		newRoom.position[1] = connectingDoorPosGlobal[1] - connectingDoorPosRel[1]
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1])
	elif newRoom.position[2] == 1:
		newRoom.position[0] = connectingDoorPosGlobal[0] + connectingDoorPosRel[1]
		newRoom.position[1] = connectingDoorPosGlobal[1] - connectingDoorPosRel[0]
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0]+1, newRoom.position[1])
	elif newRoom.position[2] == 2: # Tested - good
		newRoom.position[0] = connectingDoorPosGlobal[0] + connectingDoorPosRel[0]
		newRoom.position[1] = connectingDoorPosGlobal[1] + connectingDoorPosRel[1]
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0]+1, newRoom.position[1]-newRoomSizeGlobal[1]+1)
	elif newRoom.position[2] == 3:
		newRoom.position[0] = connectingDoorPosGlobal[0] - connectingDoorPosRel[1]
		newRoom.position[1] = connectingDoorPosGlobal[1] + connectingDoorPosRel[0]
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1]-newRoomSizeGlobal[1]+1)
	print("topLeftmostCoord: " + str(topLeftmostCoord)) # DEBUG
	
	# Check if new room conflicts/overlaps with any other rooms in the generationMatrix
	var roomConflicts:bool = false
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			if generationMatrix[toID(coords)] != -1:
				roomConflicts = true
				print("Generation of " + roomName + " conflicts with roomID " + str(generationMatrix[toID(coords)]) + " at " + str(coords))
	if roomConflicts and abortOnConflict == true:
		return false
	
	# Add the room to the roomInstances array
	roomInstances.append(newRoom)
	var newRoomID:int = roomInstances.size()-1
	
	#Connect the two doors
	connectDoors(offOfRoomID,offOfDoorID, newRoomID,connectingDoorID)
	
	#Mark the area taken up by the new room in the generationMatrix
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			generationMatrix[toID(coords)] = newRoomID
			
	print("") # DEBUG
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
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0]+1, newRoom.position[1])
	elif newRoom.position[2] == 2:
		topLeftmostCoord = Vector2(newRoom.position[0]-newRoomSizeGlobal[0]+1, newRoom.position[1]-newRoomSizeGlobal[1]+1)
	elif newRoom.position[2] == 3:
		topLeftmostCoord = Vector2(newRoom.position[0], newRoom.position[1]-newRoomSizeGlobal[1]+1)
	
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
	connectDoors(0,4, 1,1) # 0,4 <-> 1,1
	
	roomInstances.append(rooms.roomsDict.get("globRoom")) #2
	connectDoors(1,3, 2,0) # 1,3 <-> 2,0
	
	roomInstances.append(rooms.roomsDict.get("bruiserRoom")) #3
	connectDoors(1,5, 3,0) # 1,5 <-> 3,0
	
	return roomInstances

func generateDungeon(mainChainLength:int):
	# Init 50x50 matrix
	numRows = 25
	numCols = 25
	for i in range(numRows * numCols):
		generationMatrix.append(-1)
	
	# Starting room
	forceGenRoom("startingRoom", Vector3(0,0,0))
	generateRoom("sniperRoom", 1, 0, 0)
	generateRoom("bruiserRoom", 0, 1, 4, false)
	printGenMatrix()
	#for i in range(mainChainLength):
		#rooms.roomsDict[2]
		
	# Ending room
	#generateRoom("bossRoom", -1, 2)
	
	return roomInstances

func _init():
	pass
