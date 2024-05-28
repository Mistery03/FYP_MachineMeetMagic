extends TileMap

@export var ID:int = 8

@onready var doors = $Doors

@onready var door_right = $Doors/DoorRight
@onready var door_left = $Doors/DoorLeft

@onready var three_way = $"../.."


func _ready():
	
	await get_tree().create_timer(0.1).timeout
	
	if three_way.player:
		pass
		#two_way.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
