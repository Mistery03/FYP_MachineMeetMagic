extends TileMap

@export var ID:int = 128

@onready var doors = $Doors


@onready var dead_end = $"../.."
@onready var area_2d = $DoorUp/Area2D

func _ready():
	
	await get_tree().create_timer(0.1).timeout
	for door in doors.get_children():
		if !dead_end.visible:
			door.get_child(0).monitoring = false
		else:
			door.get_child(0).monitoring = true
			dead_end.doorList = doors.duplicate()
	
	#if dead_end.player:
		#dead_end.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
