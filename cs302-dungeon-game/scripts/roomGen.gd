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
	return (int(coords[1]*numCols + coords[0])%(numCols*numRows))


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
	#print("Connected doors (" + str(room1) + "," + str(door1) + ") to (" + str(room2) + "," + str(door2) + ")")

# Returns the position of a door relative to it's parent room
func getDoorPosLocal(roomID, doorID):
	var numEnterances = roomInstances[roomID].enterances.size()
	if doorID <= numEnterances-1:
		return roomInstances[roomID].enterances[doorID]
	else:
		if roomInstances[roomID].exits.size() == 0: return roomInstances[roomID].enterances[0] # PATCH - special case for glob room
		else: return roomInstances[roomID].exits[doorID - numEnterances]

# Outputs a door's coordinates and rotation relative to the map - WORKING
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
	#print("Generating " + roomName + "...") # DEBUG
	
	# Get room, throw error if roomName isn't a key in the roomsDict
	var newRoom:Rooms.room = Rooms.room.new("roomName" + " " + str(rng.randi()))
	#Rooms.room.new().copyData()
	newRoom.copyData(rooms.roomsDict.get(roomName))
	for n in newRoom.doorDests:
		n = Vector2(-1,-1)
	if newRoom == null:
		print("Given roomType " + roomName + " is not a valid Roomtype (not found in roomsDict)")
		return false
	
	# Get the global positon of the door we want to generate a room off of
	var offOfDoorPosGlobal:Vector3 = getDoorPosGlobal(offOfRoomID, offOfDoorID)
	#print("offOfDoorGlobal: " + str(offOfDoorPosGlobal)) # DEBUG

	
	# Choose a random enterance door from the new room to connect to the offOfDoor
	#var connectingDoorID:int = rng.randi_range(0,newRoom.enterances.size()-1)
	var connectingDoorID:int = doorID # DEBUG - change this back to the line above
	var connectingDoorPosRel:Vector3 = newRoom.enterances[connectingDoorID]
	#print("connectingDoorPosRel: " + str(connectingDoorPosRel)) # DEBUG
	
	# Calculate the position of the new door
	var connectingDoorPosGlobal:Vector3 = offOfDoorPosGlobal
	connectingDoorPosGlobal[2] = int(connectingDoorPosGlobal[2] + 2) % 4 # 180deg rotation
	if offOfDoorPosGlobal[2] == 0:   # offOf door facing North - connecting door is one cell up
		connectingDoorPosGlobal[1] -= 1
	elif offOfDoorPosGlobal[2] == 1: # offOf door facing East - connecting door is one cell right
		connectingDoorPosGlobal[0] += 1
	elif offOfDoorPosGlobal[2] == 2: # offOf door facing South - connecting door is one cell down
		connectingDoorPosGlobal[1] += 1
	elif offOfDoorPosGlobal[2] == 3: # offOf door facing West - connecting door is one cell left
		connectingDoorPosGlobal[0] -= 1
	#print("connectingDoorPosGlobal: " + str(connectingDoorPosGlobal)) # DEBUG
	
	# Calculate rotation of the new room
	newRoom.position[2] = int(connectingDoorPosGlobal[2] - connectingDoorPosRel[2]) % 4
	while newRoom.position[2] < 0: newRoom.position[2] += 4 # Workaround b/c modulo doesn't work as expected with negative ints
	#print("newRoom.position[2]: " + str(newRoom.position[2])) # DEBUG
	
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
	#print("topLeftmostCoord: " + str(topLeftmostCoord)) # DEBUG
	
	# Check if new room conflicts/overlaps with any other rooms in the generationMatrix
	var roomConflicts:bool = false
	for y in range(newRoomSizeGlobal.y):
		for x in range(newRoomSizeGlobal.x):
			var coords:Vector2 = topLeftmostCoord + Vector2(x,y)
			var id:int = toID(coords)
			if generationMatrix[id] != -1:
				roomConflicts = true
				#print("Generation of " + roomName + " off of roomID " + str(offOfRoomID) + " conflicts with roomID " + str(generationMatrix[toID(coords)]) + " at " + str(coords))
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
			
	#print("") # DEBUG
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

# Generates a random roomType off of one of the given room's exits
func generateRandRoom(roomID:int, roomList:Array, generationAttemptLimit:int = 50):
		# Loop until a room is generated or if the generation limit is hit
	var generationAttempts:int = 0
	while generationAttempts < generationAttemptLimit:
		# Select a random roomType
		var newRoomType:String = roomList[rng.randi_range(0, roomList.size()-1)]
		
		# Get the room data
		var newRoomData:Rooms.room = rooms.roomsDict.get(newRoomType)
		
		# Choose a random exit from the last room
		var lastRoomFirstExitID:int = roomInstances[roomID-1].enterances.size()
		var lastRoomLastExitID:int = lastRoomFirstExitID + (roomInstances[roomID-1].exits.size()-1)
		var exitID:int = rng.randi_range(lastRoomFirstExitID, lastRoomLastExitID)
		
		# Choose a random enterance from the current room
		var enteranceID:int = rng.randi_range(0, newRoomData.enterances.size()-1)
		
		# Attempt to generate the given room
		var genResult:bool = generateRoom(newRoomType, enteranceID, roomID-1, exitID)
		#print(str(roomID) + " " + str(genResult))
		
		# Room generation success
		if genResult == true:
			prints(" -Pass:", str(roomID), str(newRoomType), str(generationAttempts), str(roomInstances.size()-1))
			return true
		if genResult == false:
			generationAttempts += 1
			prints("  Fail:", str(roomID), str(newRoomType), str(generationAttempts))
	
	return false


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

# Intermediary testing function to test generateRoom()
func generateRoomTestbed():
	# Init 50x50 matrix
	numRows = 25
	numCols = 25
	for i in range(numRows * numCols):
		generationMatrix.append(-1)
	
	# Starting room
	forceGenRoom("startingRoom", Vector3(0,0,0))
	generateRoom("sniperRoom", 1, 0, 0)
	generateRoom("bruiserRoom", 0, 1, 4)
	generateRoom("normalHall", 0, 2, 5)
	generateRoom("shortHall", 0, 3, 3)
	generateRoom("sniperRoom", 0, 4, 1)
	generateRoom("longHall", 1, 5, 5)
	generateRoom("globRoom", 0, 6, 3)
	generateRoom("bossRoom", 0, 6, 4)
	printGenMatrix()
	
	## DEBUG - Print all doorDests
	#for i in [1,5]:
		#print("All doorDests for roomID " + str(i) + " " + roomInstances[i].type)
		#for n in roomInstances[i].doorDests:
			#print("  " + str(n))
	
	return roomInstances

# Generates a dungeon with a starting room, a main path, dead ends, and a boss room at the end
func generateDungeon(chainLength:int, falsePathGenerationWeights:PackedFloat32Array):
	# Init 25x25 matrix
	numRows = 25
	numCols = 25
	for i in range(numRows * numCols):
		generationMatrix.append(-1)
	
	# Create a list of all chainable rooms (all rooms - (dead end rooms + start room + boss room))
	var chainableRooms:Array = rooms.roomsDict.keys()
	var indicesToRemove:Array[int]
	for i in range(chainableRooms.size()):
		var r:Rooms.room = rooms.roomsDict.get(chainableRooms[i])
		if r.isDeadEnd or r.isSpecial:
			indicesToRemove.append(i)
	
	# Create a list of rooms that can be used as a dead end
	var deadEndRooms:Array[String] = ["sniperRoom", "bruiserRoom", "globRoom"]
	
	indicesToRemove.reverse()
	for index in indicesToRemove:
		chainableRooms.pop_at(index)
	
	# Attempt to generate dungeons until a valid dungeon is produced
	var generationSuccess:bool = false
	while generationSuccess == false:
		# Clear matrix and instances from any previous generation attempts
		generationMatrix.fill(-1)
		roomInstances.clear()
		
		# Starting room
		forceGenRoom("startingRoom", Vector3(10,0,0)) # ID = 0
		
		# Generate main chain path
		var errorOnChainGen:bool = false
		for i in range(chainLength):
			if errorOnChainGen == false:
				var genAttempt = generateRandRoom(i+1, chainableRooms)
				print(genAttempt)
				if genAttempt == false:
					errorOnChainGen = true
		if errorOnChainGen:
			print("Restarting generation...")
			continue
		
		# Boss room
		var genAttempt = generateRandRoom(chainLength+1, ["bossRoom"])
		if genAttempt == false:
			print("Restarting generation...")
			continue
		
		print("Generating false paths...")
		
		# Generate false paths/dead ends - BUG: This crashed the game a lot during testing and I don't know if I have the issue fixed -ND
		var startingNumRooms = roomInstances.size()
		
		# For every room...
		for i in range(startingNumRooms):
			# Get range of exit doorIDs
			var firstExitID:int = roomInstances[i].enterances.size()
			var lastExitID:int = firstExitID + (roomInstances[i].exits.size()-1)
			
			# For every exit...
			for j in range(firstExitID, lastExitID):
				# Choose path length
				var pathLength:int = rng.rand_weighted(falsePathGenerationWeights)
				
				if roomInstances[i].doorDests[j] == Vector2(-1,-1) and pathLength != 0:
					var abortPathGen:bool = false
					var RIsizeBeforePathGen = roomInstances.size()
					
					print("Generating path " + str(pathLength) + " off of ID " + str(i))
					
					# Generate a path of the given length off of the given room
					var lastRoomInstanceID:int = roomInstances.size()-1
					var offOfRoomID:int = i
					for k in range(pathLength):
						if abortPathGen == true: break
						
						var genResult:bool
						
						if k != 0: offOfRoomID = lastRoomInstanceID + k + 1
						if k == pathLength-1: genResult = generateRandRoom(offOfRoomID, deadEndRooms) # Last room in false path should be a dead end room
						else: genResult = generateRandRoom(offOfRoomID, chainableRooms) # Otherwise, generate a chain room
						
						# If generation fails, delete entire path and abort path generation
						if genResult == false:
							while roomInstances.size() != RIsizeBeforePathGen:
								var IDtoDelete:int = roomInstances.size()-1
								prints("  Deleting roomID", str(IDtoDelete))
								roomInstances.pop_back() # Delete off of roomInstances
								for n in range(generationMatrix.size()): # Delete off of genMatrix
									if generationMatrix[n] == IDtoDelete: generationMatrix[n] = -1
								
								for room in roomInstances: # Delete any room connections
									for doorDest in room.doorDests:
										if doorDest[0] == IDtoDelete:
											print("    Deleted connection to " + str(doorDest))
											doorDest = Vector2(-1,-1)
								
							abortPathGen = true
			
		
		
		generationSuccess = true
	
	printGenMatrix()
	
	return roomInstances

func _init():
	pass
