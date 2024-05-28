extends TileMap

@export var ID:int = 129

@onready var doors = $Doors

@onready var dead_end = $"../.."



func _ready():
	for door in doors.get_children():
		door.roomID = ID
	await get_tree().create_timer(0.1).timeout
	
			
#	if dead_end.player:
		#dead_end.player.position = door_right.position - Vector2(30,0)
		#dead_end.player.animation.play("IDLESIDE")
		#dead_end.player.animation.flip_h = true
