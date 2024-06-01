extends Node2D

@export var startingArea:PackedScene
@export var maxEnemyRooms:int = 2

@export var player:Player

@onready var rooms = $Rooms
@onready var fade_out = $CanvasLayer/FadeOut

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,1.5)
	var room = startingArea.instantiate()
	room.setPlayer(player)
	rooms.add_child(room)
	room.placePlayer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 	
