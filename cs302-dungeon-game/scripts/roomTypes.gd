class_name Rooms

# Main array with all room types (switch to dict maybe?)
var roomsArray: Array[room]

# generic room class
class room:
	var size: Vector2
	var enterences: Array[Vector3]
	var exits: Array[Vector3]
	var enemies: Array[String] # change this maybe?

# Example for defining a room
func longHall():
	var longHall = room.new()
	
	longHall.size = Vector2(4,1)
	
	# Doors are described as a 3d Vector containing [xCoord, yCoord, direction] with 0=north, 1=east, 2=south, 3=west
	longHall.enterences.append(Vector3(0,0,0))
	longHall.enterences.append(Vector3(0,0,2))
	longHall.enterences.append(Vector3(0,0,3))  
	
	longHall.exits.append(Vector3(3,0,0))
	longHall.exits.append(Vector3(3,0,1))
	longHall.exits.append(Vector3(3,0,2))
	
	longHall.enemies.append("light")
	longHall.enemies.append("light")
	longHall.enemies.append("medium")
	longHall.enemies.append("medium")
	longHall.enemies.append("sniper")
	
	return longHall


func _init():
	# append all rooms to main array in init function
	roomsArray.append(longHall())
