extends TreeGraphGeneration

@export var DegreeRoom:Dictionary
@onready var rooms = $Rooms
@export var player:Player

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
		var room = DegreeRoom.get(getAdjacencyDegree(int(node))).instantiate()
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
	currRoom.position = Vector2.ZERO	
	currRoom.isStartingRoom = true


	
	
	
func changeRoom(roomNumber,roomID,doorOrientation):
	
	doorList.clear()
	doorList = roomList[roomNumber].room_sets.get_child(0).doors.get_children()
	var entrance
	for door in doorList:
		if door.orientation == doorOrientation:
			print(door)
	for index in len(roomList):
		if roomList[index].roomNum == roomNumber:
			currRoom.position = Vector2(1600,1600)
			roomList[index].position = Vector2(0,0)
			player.position = Vector2(0,0)
			currRoom = roomList[index]
	#print(roomID)

func setDoorRoomNumber(currRoomNum:int):
	doorList.clear()
	
	doorList = roomList[currRoomNum].room_sets.get_child(0).doors.get_children()
	var adjacency_values = getAdjacencyValueByKey(currRoomNum)

	# Ensure you only iterate over the minimum length of both arrays
	var limit = min(adjacency_values.size(), doorList.size())
	
	for i in range(limit):
		doorList[i].roomNumber = adjacency_values[i]
		doorList[i].connect("OnDoorEntered",changeRoom)
	
