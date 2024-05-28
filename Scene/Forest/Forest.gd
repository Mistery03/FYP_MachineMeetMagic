extends TreeGraphGeneration



@export var degreeRoom:Dictionary
@export var orientationLookUp:Dictionary ={
	"UP":"",
	"RIGHT":"",
	"DOWN":"",
	"LEFT":""
}


@export var player:Player

@onready var rooms = $Rooms
var roomList:Array = []
var doorList:Array = []

var currRoom

var index:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	create_spanning_tree(maxNodes)
	print_adjacency_list()
	
	roomList.clear()
	index = 0
	for node in getAdjacencyDegreeList():
		var room = degreeRoom.get(getAdjacencyDegree(int(node))).instantiate()
		room.position = Vector2(1600,1600)
		if player:
			room.player = player
		room.roomNum = index
		roomList.append(room)
		rooms.add_child(room)
		index+= 1
	

	for index in len(roomList):
		setDoorRoomNumber(index)
		
	currRoom = roomList[0]
	currRoom.isStartingRoom = true
	currRoom.position = Vector2.ZERO	
	


	
	
	
func changeRoom(roomNumber,roomID,doorOrientation):
	currRoom.isStartingRoom = false
	doorList.clear()
	var getDirection = orientationLookUp.get(doorOrientation)
	
	if roomList[roomNumber].room_sets.get_child_count() > 1:
		var roomSets = roomList[roomNumber].room_sets.get_children()
		for room in roomSets:
			doorList =room.doors.get_children()
	else:
		doorList = roomList[roomNumber].room_sets.get_child(0).doors.get_children()

	var entrance
	for door in doorList:
		print(door.orientation)
		if door.orientation == getDirection:
			entrance = door
			print(entrance)
			#roomList[entrance.roomNumber].selectedRoom(entrance.roomID)
		
	"""var getDirection = orientationLookUp.get(doorOrientation)

	var entrance
	for door in doorList:
		if door.orientation == getDirection:
			entrance = door
			#roomList[entrance.roomNumber].selectedRoom(entrance.roomID)
			
	for index in len(roomList):
		if roomList[index].roomNum == roomNumber:
			
			currRoom.position = Vector2(1600,1600)
			roomList[index].position = Vector2(0,0)
			if entrance.orientation == "UP":
				player.position = entrance.position + Vector2(0,30)
			if entrance.orientation == "DOWN":
				player.position = entrance.position - Vector2(0,30)
			if entrance.orientation == "RIGHT":
				player.position = entrance.position + Vector2(30,0)
			if entrance.orientation == "LEFT":
				player.position = entrance.position - Vector2(30,0)
			currRoom = roomList[index]
	#print(roomID)"""

func setDoorRoomNumber(currRoomNum:int):
	doorList.clear()
	if roomList[currRoomNum].room_sets.get_child_count() > 1:
		print("Numvered test")
		var roomSets = roomList[currRoomNum].room_sets.get_children()
		for room in roomSets:
			doorList =room.doors.get_children()
			
		var adjacency_values = getAdjacencyValueByKey(currRoomNum)

		# Ensure you only iterate over the minimum length of both arrays
		var limit = min(adjacency_values.size(), doorList.size())
		
		for i in range(limit):
			doorList[i].roomNumber = adjacency_values[i]
			doorList[i].connect("OnDoorEntered",changeRoom)
	else:
		print("one test")
		doorList = roomList[currRoomNum].room_sets.get_child(0).doors.get_children()
		
		var adjacency_values = getAdjacencyValueByKey(currRoomNum)

		# Ensure you only iterate over the minimum length of both arrays
		var limit = min(adjacency_values.size(), doorList.size())
		
		for i in range(limit):
			doorList[i].roomNumber = adjacency_values[i]
			doorList[i].connect("OnDoorEntered",changeRoom)
	
