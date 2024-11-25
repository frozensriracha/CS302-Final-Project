class_name RoomGen

var rooms = Rooms.new() # import room types
var array2D = [] # 2d array to check for overlap

var roomInstances: Array[Rooms.room] # Array that holds the data for each room in the dungeon

# DEBUG
func checkInit():
	print("RoomGen initialized successfully")
	pass
	

# Generates a demo dungeon with four connected rooms to test other functions
func generateDemoDungeon():
	roomInstances.append(rooms.roomsDict.get("sniperRoom")) #0
	roomInstances.append(rooms.roomsDict.get("normalHall")) #1
	roomInstances[0].doorDests[4] = Vector2(1, 1) # 0,4 -> 1,1
	roomInstances[1].doorDests[1] = Vector2(0, 4) # vice-versa
	
	roomInstances.append(rooms.roomsDict.get("globRoom")) #2
	roomInstances[1].doorDests[3] = Vector2(2,0) # 1,3 -> 2,0
	roomInstances[2].doorDests[0] = Vector2(1,3) # vice-versa
	
	roomInstances.append(rooms.roomsDict.get("bruiserRoom")) #3
	roomInstances[1].doorDests[5] = Vector2(3,0) # 1,5 -> 3,0
	roomInstances[3].doorDests[0] = Vector2(1,5) # vice-versa
	
	return roomInstances

# return a vector of room instances
func generateRoom():
	pass

func _init():
	pass
