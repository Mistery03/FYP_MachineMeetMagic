extends TileMap

@export var ID:int = 129

@onready var doors = $Doors

@onready var dead_end = $"../.."

@onready var area_2d = $DoorRight/Area2D

func _ready():
	
	await get_tree().create_timer(0.1).timeout
	for door in doors.get_children():
		if !dead_end.visible:
			door.get_child(0).monitoring = false
		else:
			door.get_child(0).monitoring = true
			dead_end.doorList = doors.duplicate()
#	if dead_end.player:
		#dead_end.player.position = door_right.position - Vector2(30,0)
		#dead_end.player.animation.play("IDLESIDE")
		#dead_end.player.animation.flip_h = true
