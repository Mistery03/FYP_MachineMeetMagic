extends Node2D

@export var isStartingRoom:bool
@export var PK_roomID:int = 2
@export var roomID:int = 2
@export var player:Player

@onready var room_oritentation = $RoomOritentation

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if !isStartingRoom:
		roomID  = randi_range(2,3)
	

	for room in room_oritentation.get_children():
		if room.ID != roomID:
			room.queue_free()



