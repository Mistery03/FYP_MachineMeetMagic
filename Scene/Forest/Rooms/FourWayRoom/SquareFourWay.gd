extends TileMap

@export var ID:int = 16

@onready var doors = $Doors

@onready var door_right = $Doors/DoorRight
@onready var door_left = $Doors/DoorLeft
@onready var door_down = $Doors/DoorDown
@onready var door_up = $Doors/DoorUp

@onready var four_way = $"../.."



func _ready():
	
			
	await get_tree().create_timer(0.1).timeout
	for door in doors.get_children():
		if !four_way.visible:
			door.get_child(0).monitoring = false
		else:
			door.get_child(0).monitoring = true
	if four_way.player:
		pass
		#two_way.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
