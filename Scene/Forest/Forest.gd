extends Node2D

@export var startingArea:PackedScene
@export var enemyRooms:Array[PackedScene]
@export var bossArea:PackedScene
@export var maxEnemyRooms:int = 2


@export var player:Player

@onready var rooms = $Rooms
@onready var fade_out = $CanvasLayer/FadeOut

var enemyRoomQueue:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,1.5)
	var room = startingArea.instantiate()
	room.setPlayer(player)
	rooms.add_child(room)
	room.placePlayer()
	room.door.connect("OnDoorEntered",goNextRoom)
	room.fadeOut = fade_out
	enemyRoomQueue.push_back(bossArea)
	for i in range(maxEnemyRooms):
		randomiseEnemyRoom()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 	
	
func clearCurrentRoom():
	rooms.get_child(0).queue_free()

func randomiseEnemyRoom():
	var selectedRoom = enemyRooms.pick_random()
	enemyRoomQueue.push_front(selectedRoom)

func spawnRoom():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,1.5)
	var selectedRoom = enemyRoomQueue.pop_front()
	print(selectedRoom)
	var roomInstance = selectedRoom.instantiate()
	roomInstance.setPlayer(player)
	roomInstance.position = Vector2(0,0)
	if roomInstance.roomName != "BossRoom":
		roomInstance.door.connect("OnDoorEntered",goNextRoom)
	roomInstance.fadeOut = fade_out
	rooms.add_child(roomInstance)
	roomInstance.placePlayer()
	

func goNextRoom():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",1,0.3)
	await  get_tree().create_timer(0.5).timeout
	clearCurrentRoom()
	await  get_tree().create_timer(1).timeout
	spawnRoom()
	
