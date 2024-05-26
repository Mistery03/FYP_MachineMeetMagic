extends Node2D

@export var isStartingRoom:bool
@export var PK_roomID:int = 2
@export var roomID:int = 2
@export var player:Player

@onready var room_sets = $RoomSets

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var IDList:Array = []
	for room in room_sets.get_children():
		IDList.append(room.ID)
		
	if isStartingRoom:
		roomID  = IDList.pick_random()
		player.position = Vector2(0,0)
	
		
	

	for room in room_sets.get_children():
		if room.ID != roomID:
			room.queue_free()



