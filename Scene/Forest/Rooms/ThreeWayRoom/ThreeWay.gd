extends Node2D

@export var isStartingRoom:bool
@export var PK_roomID:int = 2
@export var roomID:int = 2
@export var player:Player
@export var roomNum:int = 0

@onready var room_sets = $RoomSets

var doorList:Array = []
var IDList:Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	for room in room_sets.get_children():
		IDList.append(room.ID)
		
	roomID  = IDList.pick_random()	
	for room in room_sets.get_children():
		if room.ID != roomID:
			room.queue_free()
	
	#print(room_sets.get_child(0).doors.get_children())



