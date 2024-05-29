extends TileMap

@export var ID:int = 130

@onready var doors = $Doors


@onready var dead_end = $"../.."


func _ready():
	for door in doors.get_children():
		door.roomID = ID
	await get_tree().create_timer(0.1).timeout
	
			
	#if dead_end.player:
		#dead_end.player.position = door_down.position - Vector2(0,30)
		#dead_end.player.animation.play("WALKBACKWARD")


