class_name Rooms

# Main array with all room types TODO: SWITCH TO DICT
var roomsArray: Array[room]

# generic room class
class room:
	var size: Vector2
	var enterences: Array[Vector3]
	var exits: Array[Vector3]

# Example for defining a room
func longHall():
	var longHall = room.new()
	
	longHall.size = Vector2(5,1)
	
	# Doors are described as a 3d Vector containing [xCoord, yCoord, direction] with 0=north, 1=east, 2=south, 3=west
	longHall.enterences.append(Vector3(0,0,0))
	longHall.enterences.append(Vector3(0,0,2))
	longHall.enterences.append(Vector3(0,0,3))  
	
	longHall.exits.append(Vector3(4,0,0))
	longHall.exits.append(Vector3(4,0,1))
	longHall.exits.append(Vector3(4,0,2))
	
	return longHall

func normalHall():
	var normalHall = room.new()
	
	normalHall.size = Vector2(4,1)
	
	normalHall.enterences.append(Vector3(0,0,0))
	normalHall.enterences.append(Vector3(0,0,2))
	normalHall.enterences.append(Vector3(0,0,3))  
	
	normalHall.exits.append(Vector3(3,0,0))
	normalHall.exits.append(Vector3(3,0,1))
	normalHall.exits.append(Vector3(3,0,2))
	
	return normalHall

func shortHall():
	var shortHall = room.new()
	
	shortHall.size = Vector2(2,1)
	
	shortHall.enterences.append(Vector3(0,0,3)) 
	
	shortHall.exits.append(Vector3(2,0,1))

	
	return normalHall


func _init():
	# append all rooms to main array in init function
	roomsArray.append(longHall())
	roomsArray.append(normalHall())
	roomsArray.append(shortHall())
