extends TileMap

@export var ID:int = 128

@onready var door_up = $DoorUp

@onready var dead_end = $"../.."
@onready var area_2d = $DoorUp/Area2D

func _ready():
	
	await get_tree().create_timer(0.1).timeout
	if !dead_end.visible:
		area_2d.monitoring = false
	else:
		area_2d.monitoring = true
	if dead_end.player:
		dead_end.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
