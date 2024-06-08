extends Node2D

@export_category("Level Settings")
@export var startingArea:PackedScene
@export var enemyRooms:Array[PackedScene]
@export var bossArea:PackedScene
@export var maxEnemyRooms:int = 2

@export_category("Player Setting")
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
	player.levelTilemap = room.tile_map
	rooms.add_child(room)
	room.placePlayer()
	room.door.connect("OnDoorEntered",goNextRoom)
	room.fadeOut = fade_out
	
	enemyRoomQueue.push_back(bossArea)
	for i in range(maxEnemyRooms):
		randomiseEnemyRoom()
	
	await get_tree().create_timer(0.2).timeout
	player.objectsPosInLevelList.clear()
	player.objectsPosInLevelList = room.objectPosList


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 	
	
func clearCurrentRoom():
	rooms.get_child(0).door.disconnect("OnDoorEntered",goNextRoom)
	rooms.get_child(0).queue_free()

func randomiseEnemyRoom():
	var selectedRoom = enemyRooms.pick_random()
	enemyRoomQueue.push_front(selectedRoom)
	#print(enemyRoomQueue)

func spawnRoom():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",0,1.5)
	var selectedRoom = enemyRoomQueue.pop_front()
	#print(selectedRoom)
	var roomInstance = selectedRoom.instantiate()
	roomInstance.setPlayer(player)
	player.levelTilemap = roomInstance.tile_map
	roomInstance.position = Vector2(0,0)
	if roomInstance.roomName != "BossRoom":
		roomInstance.door.connect("OnDoorEntered",goNextRoom)
	roomInstance.fadeOut = fade_out
	rooms.add_child(roomInstance)
	roomInstance.placePlayer()
	player.isLevelTransitioning = false
	
	await get_tree().create_timer(0.2).timeout
	player.objectsPosInLevelList.clear()
	player.objectsPosInLevelList = roomInstance.objectPosList
	

func goNextRoom():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",1,0.3)
	await  get_tree().create_timer(0.5).timeout
	player.isLevelTransitioning = true
	clearCurrentRoom()
	await  get_tree().create_timer(1).timeout
	spawnRoom()
	
