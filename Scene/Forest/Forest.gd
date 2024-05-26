extends TreeGraphGeneration

@export var DegreeRoom:Dictionary
@onready var rooms = $Rooms
@export var player:Player

var roomList:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_spanning_tree(maxNodes)
	print_adjacency_list()
	roomList.clear()
	for node in getAdjacencyDegreeList():
		var room = DegreeRoom.get(getAdjacencyDegree(int(node))).instantiate()
		room.visible = false
		if player:
			room.player = player
		roomList.append(room)
		rooms.add_child(room)
		
	roomList[0].visible = true
	roomList[0].isStartingRoom = true
