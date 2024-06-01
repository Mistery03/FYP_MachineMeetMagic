extends Node2D

@export var startingArea:PackedScene
@export var player:Player

@onready var rooms = $Rooms

# Called when the node enters the scene tree for the first time.
func _ready():
	var room = startingArea.instantiate()
	room.setPlayer(player)
	rooms.add_child(room)
	room.placePlayer()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 	
