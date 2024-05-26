extends Node2D

@export var isStartingRoom:bool
@export var PK_roomID:int = 128
@export var roomID:int
@export var player:Player

@onready var room_oritentation = $RoomOritentation

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if !isStartingRoom:
		roomID  = randi_range(128,131)
	

	for room in room_oritentation.get_children():
		if room.ID != roomID:
			room.queue_free()



