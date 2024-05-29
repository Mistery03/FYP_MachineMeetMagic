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
		initDoorFunction(index)
		
	currRoom = roomList[0]
	currRoom.position = Vector2.ZERO	
	


	
	
	
func changeRoom(roomNumber,roomID,doorOrientation):
	print("Player entered door")
	print(roomNumber)
	currRoom.isStartingRoom = false
	doorList.clear()
	var getDirection = orientationLookUp.get(doorOrientation)
	
	#print(roomID)
	#roomList[roomNumber].selectedRoom(roomID)
	
	var doorSets
	for sets in roomList[roomNumber].room_sets.get_children():
		doorSets = sets.doors.get_children()
	
	for doors in doorSets:
		print(doors)
		if doors.orientation == getDirection:
			print(doors)
	
	#doorList = roomList[roomNumber].room_sets.get_children()

	#var entrance
	#for door in doorList:
		#if door.orientation == getDirection:
			#entrance = door
			#print(entrance)
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

func initDoorFunction(currRoomNum:int):
	doorList.clear()
	
	doorList = roomList[currRoomNum].room_sets.get_child(0).doors.get_children()
	var adjacency_values = getAdjacencyValueByKey(currRoomNum)

	# Ensure you only iterate over the minimum length of both arrays
	var limit = min(adjacency_values.size(), doorList.size())
	
	for i in range(limit):
		doorList[i].roomNumber = adjacency_values[i]
		doorList[i].connect("OnDoorEntered",changeRoom)

	
