extends TileMap

@export var ID:int = 2

@onready var doors = $Doors

@onready var door_up = $Doors/DoorUp
@onready var door_down = $Doors/DoorDown

@onready var two_way = $"../.."



func _ready():
	
	await get_tree().create_timer(0.1).timeout
	for door in doors.get_children():
		if !two_way.visible:
			door.get_child(0).monitoring = false
		else:
			door.get_child(0).monitoring = true
	#if two_way.player:
		#two_way.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
