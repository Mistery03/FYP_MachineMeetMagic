extends TileMap

@export var ID:int = 3


@onready var two_way = $"../.."

@onready var doors = $Doors
@onready var door_right = $Doors/DoorRight
@onready var door_left = $Doors/DoorLeft

func _ready():
	for door in doors:
		door.roomID = ID
	await get_tree().create_timer(0.1).timeout
	
	if two_way.player:
		pass
		#two_way.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
