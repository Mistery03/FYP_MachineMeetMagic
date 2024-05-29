extends TreeGraphGeneration



@export var degreeRoom:Dictionary



@export var player:Player

@onready var rooms = $Rooms
@onready var fade_out = $CanvasLayer/FadeOut

var roomList:Array = []
var doorList:Array = []

var currRoom

var index:int = 0

var didPlayerEntered:bool = false


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
	

	await get_tree().create_timer(0.5).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,0.5)
	#for index in len(roomList):
		#initDoorFunction(index)
	for index in len(roomList):
		initDoorFunction(index)	
		
	currRoom = roomList[0]
	setDoorRoomNumber(0)
	currRoom.position = Vector2.ZERO	
	
	
	
func changeRoom(roomNumber,roomID,prevRoomNumber):
	print("Player entered door")
	print("The curr Room number: ",roomNumber)
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(fade_out,"modulate:a",0,1.5)
	#doorList.clear()
	await get_tree().create_timer(0.6).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,1)
	if !didPlayerEntered:
		for index in len(roomList):
			if roomList[index].roomNum == roomNumber:
				currRoom.position = Vector2(1600,1600)
				roomList[index].position = Vector2(0,0)
				
				currRoom = roomList[index]
				
				setDoorRoomNumber(currRoom.roomNum)
				doorList = currRoom.room_sets.get_child(0).doors.get_children()
				for door in doorList:
					print("Check no:",door.roomNumber)
					if door.roomNumber == prevRoomNumber:
						print("test")
						door.flag.visible = true
				player.position =  Vector2(0,0)
					
				
				didPlayerEntered = true
				
	await get_tree().create_timer(2).timeout
	didPlayerEntered = false
	
	#doorList = roomList[roomNumber].room_sets.get_children()

	#var entrance
	#for door in doorList:
		#if door.orientation == getDirection:
			#entrance = door
			#print(entrance)
			#roomList[entrance.roomNumber].selectedRoom(entrance.roomID)
		

func initDoorFunction(currRoomNum:int):
	doorList.clear()
	#print(roomList[currRoomNum].room_sets.get_children())
	for sets in roomList[currRoomNum].room_sets.get_children():
		#print(currRoomNum,sets)
		for door in sets.doors.get_children():
			#print(door)
			door.connect("OnDoorEntered",changeRoom)
			door.fadeOut = fade_out
	
	
		#doorList[i].connect("OnDoorEntered",changeRoom)

func setDoorRoomNumber(currRoomNum:int):	
	doorList = roomList[currRoomNum].room_sets.get_child(0).doors.get_children()
	var adjacency_values = getAdjacencyValueByKey(currRoomNum)

	# Ensure you only iterate over the minimum length of both arrays
	var limit = min(adjacency_values.size(), doorList.size())
	
	for i in range(limit):
		doorList[i].roomNumber = adjacency_values[i]
		doorList[i].prevRoomNumber = i
