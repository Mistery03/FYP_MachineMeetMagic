extends Node2D

@export_category("Level Settings")
@export var startingArea:PackedScene
@export var enemyRooms:Array[PackedScene]
@export var bossArea:PackedScene
@export var maxEnemyRooms:int = 2

@export_category("Player Setting")
@export var player:Player
@export var isBuildEnabled:bool = false

@onready var rooms = $Rooms
@onready var fade_out = $CanvasLayer/FadeOut

@onready var wind_sfx = $windSFX

var enemyRoomQueue:Array = []

var last_selected_room


func init(player:Player):
	self.player = player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.isBuildEnabled = isBuildEnabled
	wind_sfx.play()
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
	if enemyRoomQueue.size() > 0:
		last_selected_room = enemyRoomQueue[0]
	else:
		last_selected_room = null

	var selectedRoom = enemyRooms.pick_random()

	# Ensure the selected room is not the same as the last selected room
	while selectedRoom == last_selected_room:
		selectedRoom = enemyRooms.pick_random()

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
	
	if roomInstance.roomName != "BossRoom":
		await get_tree().create_timer(1).timeout
		roomInstance.spawnCreatures()


func goNextRoom():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_out,"modulate:a",1,0.3)
	await  get_tree().create_timer(0.5).timeout
	player.isLevelTransitioning = true
	player.currStamina = player.playerData.MaxStamina
	clearCurrentRoom()
	await  get_tree().create_timer(1).timeout
	spawnRoom()

