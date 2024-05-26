extends TileMap

@export var ID:int = 131

@onready var door_left = $DoorLeft

@onready var dead_end = $"../.."
@onready var area_2d = $DoorLeft/Area2D

func _ready():
	
	await get_tree().create_timer(0.1).timeout
	if !dead_end.visible:
		area_2d.monitoring = false
	else:
		area_2d.monitoring = true
	#if dead_end.player:
		#dead_end.player.position = door_left.position + Vector2(30,0)
		#dead_end.player.animation.play("IDLESIDE")
