class_name Rooms

# Main dict with all room types
var roomsDict = {}

# generic room class
class room:
	var type: String
	var size: Vector2
	var enterances: Array[Vector3]
	var exits: Array[Vector3]
	var doorDests: Array[Vector2] # doorDests[doorID] = (roomID,doorID)
	var position:Vector3 = Vector3(0,0,0) # Notation as described in line 24
	var defeated:bool = false # Set to true when the player defeats all enemies in the instance
	var isDeadEnd:bool = false # True when room has no exits
	var isSpecial:bool = false # True for start and end rooms
	
	func _init(name) -> void:
		type = name
	
	func copyData(otherRoom:room):
		self.type = otherRoom.type
		self.size = otherRoom.size
		self.enterances = otherRoom.enterances
		self.exits = otherRoom.exits
		self.doorDests.resize(otherRoom.doorDests.size())
		self.doorDests.fill(Vector2(-1,-1))
		self.position = otherRoom.position
		self.defeated = false
		self.isDeadEnd = otherRoom.isDeadEnd
		self.isSpecial = otherRoom.isSpecial

# Room Definitions
func longHall():
	var newRoomType = room.new("longHall")
	
	newRoomType.size = Vector2(5,1)
	
	# Doors are described as a 3d Vector containing [xCoord, yCoord, direction] with 0=north, 1=east, 2=south, 3=west
	newRoomType.enterances.append(Vector3(0,0,0))
	newRoomType.enterances.append(Vector3(0,0,2))
	newRoomType.enterances.append(Vector3(0,0,3))  
	
	newRoomType.exits.append(Vector3(4,0,0))
	newRoomType.exits.append(Vector3(4,0,1))
	newRoomType.exits.append(Vector3(4,0,2))
	
	newRoomType.doorDests.resize(6)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	return newRoomType

func normalHall():
	var newRoomType = room.new("normalHall")
	
	newRoomType.size = Vector2(4,1)
	
	newRoomType.enterances.append(Vector3(0,0,0))
	newRoomType.enterances.append(Vector3(0,0,2))
	newRoomType.enterances.append(Vector3(0,0,3))  
	
	newRoomType.exits.append(Vector3(3,0,0))
	newRoomType.exits.append(Vector3(3,0,1))
	newRoomType.exits.append(Vector3(3,0,2))
	
	newRoomType.doorDests.resize(6)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	return newRoomType

func shortHall():
	var newRoomType = room.new("shortHall")
	
	newRoomType.size = Vector2(3,1)
	
	newRoomType.enterances.append(Vector3(0,0,3)) 
	
	newRoomType.exits.append(Vector3(2,0,1))
	
	newRoomType.doorDests.resize(2)
	newRoomType.doorDests.fill(Vector2(-1,-1))

	
	return newRoomType

func globRoom():
	var newRoomType = room.new("globRoom")
	
	newRoomType.size = Vector2(2,2)
	
	newRoomType.enterances.append(Vector3(1,1,2)) 
	
	newRoomType.doorDests.resize(1)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	newRoomType.isDeadEnd = true
	
	return newRoomType

func sniperRoom():
	var newRoomType = room.new("sniperRoom")
	
	newRoomType.size = Vector2(3,4)
	
	newRoomType.enterances.append(Vector3(0,3,2)) 
	newRoomType.enterances.append(Vector3(1,3,2))
	newRoomType.enterances.append(Vector3(2,3,2))
	
	newRoomType.exits.append(Vector3(0,0,3))
	newRoomType.exits.append(Vector3(1,0,0))
	newRoomType.exits.append(Vector3(2,0,1))
	
	newRoomType.doorDests.resize(6)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	return newRoomType

func bruiserRoom():
	var newRoomType = room.new("bruiserRoom")
	
	newRoomType.size = Vector2(4,3)
	
	newRoomType.enterances.append(Vector3(1,0,0))
	newRoomType.enterances.append(Vector3(2,0,0))
	
	newRoomType.exits.append(Vector3(0,2,3))
	newRoomType.exits.append(Vector3(0,2,2))
	newRoomType.exits.append(Vector3(1,2,2))
	newRoomType.exits.append(Vector3(2,2,2))
	newRoomType.exits.append(Vector3(3,2,2))
	newRoomType.exits.append(Vector3(3,2,1))
	
	newRoomType.doorDests.resize(8)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	return newRoomType

func startingRoom():
	var newRoomType = room.new("startingRoom")
	
	newRoomType.size = Vector2(2,2)
	
	newRoomType.exits.append(Vector3(1,1,2)) 
	
	newRoomType.doorDests.resize(1)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	newRoomType.isSpecial = true
	
	return newRoomType

func bossRoom():
	var newRoomType = room.new("bossRoom")
	
	newRoomType.size = Vector2(5,5)
	
	newRoomType.enterances.append(Vector3(2,0,0)) 
	
	newRoomType.exits.append(Vector3(2,4,2))
	
	newRoomType.doorDests.resize(2)
	newRoomType.doorDests.fill(Vector2(-1,-1))
	
	newRoomType.isSpecial = true
	
	return newRoomType

func _init():
	# append all rooms to main array in init function
	roomsDict["longHall"] = longHall()
	roomsDict["normalHall"] = normalHall()
	roomsDict["shortHall"] = shortHall()
	roomsDict["globRoom"] = globRoom()
	roomsDict["sniperRoom"] = sniperRoom()
	roomsDict["bruiserRoom"] = bruiserRoom()
	roomsDict["startingRoom"] = startingRoom()
	roomsDict["bossRoom"] = bossRoom()
	print("Rooms Dict initialized")
	
