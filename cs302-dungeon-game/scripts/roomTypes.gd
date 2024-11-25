class_name Rooms

# Main dict with all room types
var roomsDict = {}

# generic room class
class room:
	var type: String
	var size: Vector2
	var enterences: Array[Vector3]
	var exits: Array[Vector3]
	var doorDests: Array[Vector2] # doorDests[doorID] = (roomID,doorID)
	
	func _init(name) -> void:
		type = name

# Room Definitions
func longHall():
	var longHall = room.new("longHall")
	
	longHall.size = Vector2(5,1)
	
	# Doors are described as a 3d Vector containing [xCoord, yCoord, direction] with 0=north, 1=east, 2=south, 3=west
	longHall.enterences.append(Vector3(0,0,0))
	longHall.enterences.append(Vector3(0,0,2))
	longHall.enterences.append(Vector3(0,0,3))  
	
	longHall.exits.append(Vector3(4,0,0))
	longHall.exits.append(Vector3(4,0,1))
	longHall.exits.append(Vector3(4,0,2))
	
	longHall.doorDests.resize(6)
	
	return longHall

func normalHall():
	var normalHall = room.new("normalHall")
	
	normalHall.size = Vector2(4,1)
	
	normalHall.enterences.append(Vector3(0,0,0))
	normalHall.enterences.append(Vector3(0,0,2))
	normalHall.enterences.append(Vector3(0,0,3))  
	
	normalHall.exits.append(Vector3(3,0,0))
	normalHall.exits.append(Vector3(3,0,1))
	normalHall.exits.append(Vector3(3,0,2))
	
	normalHall.doorDests.resize(6)
	
	return normalHall

func shortHall():
	var shortHall = room.new("shortHall")
	
	shortHall.size = Vector2(2,1)
	
	shortHall.enterences.append(Vector3(0,0,3)) 
	
	shortHall.exits.append(Vector3(2,0,1))
	
	shortHall.doorDests.resize(2)
	
	return shortHall

func globRoom():
	var globRoom = room.new("globRoom")
	
	globRoom.size = Vector2(2,2)
	
	globRoom.enterences.append(Vector3(1,1,2)) 
	
	globRoom.doorDests.resize(1)
	
	return globRoom

func sniperRoom():
	var sniperRoom = room.new("sniperRoom")
	
	sniperRoom.size = Vector2(3,4)
	
	sniperRoom.enterences.append(Vector3(0,3,2)) 
	sniperRoom.enterences.append(Vector3(1,3,2))
	sniperRoom.enterences.append(Vector3(2,3,2))
	
	sniperRoom.exits.append(Vector3(0,0,3))
	sniperRoom.exits.append(Vector3(1,0,0))
	sniperRoom.exits.append(Vector3(2,0,1))
	
	sniperRoom.doorDests.resize(6)
	
	return sniperRoom

func bruiserRoom():
	var bruiserRoom = room.new("bruiserRoom")
	
	bruiserRoom.size = Vector2(3,4)
	
	bruiserRoom.enterences.append(Vector3(1,0,2))
	bruiserRoom.enterences.append(Vector3(2,0,2))
	
	bruiserRoom.exits.append(Vector3(0,2,3))
	bruiserRoom.exits.append(Vector3(0,2,2))
	bruiserRoom.exits.append(Vector3(1,2,2))
	bruiserRoom.exits.append(Vector3(2,2,2))
	bruiserRoom.exits.append(Vector3(3,2,2))
	bruiserRoom.exits.append(Vector3(3,2,1))
	
	bruiserRoom.doorDests.resize(8)
	
	return bruiserRoom


func _init():
	# append all rooms to main array in init function
	roomsDict["longHall"] = longHall()
	roomsDict["normalHall"] = normalHall()
	roomsDict["shortHall"] = shortHall()
	roomsDict["globRoom"] = globRoom()
	roomsDict["sniperRoom"] = sniperRoom()
	roomsDict["bruiserRoom"] = bruiserRoom()
	print("Rooms Dict initialized")
	
