class_name RoomGen

var rooms = Rooms.new() # import room types
var array2D = [] # 2d array to check for overlap

# DEBUG
func checkInit():
	print("RoomGen initialized successfully")
	pass

# DEBUG
func checkRoomArray():
	print(rooms.roomsArray[0].size)
	pass

# return a vector of room instances
func generateRoom():
	print(rooms.roomsArray[0].size)
	pass

func _init():
	pass
