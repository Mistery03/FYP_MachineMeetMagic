extends TileMap

@export var ID:int = 129

@onready var door_right = $DoorRight

@onready var dead_end = $"../.."

@onready var area_2d = $DoorRight/Area2D

func _ready():
	
	await get_tree().create_timer(0.1).timeout
	if !dead_end.visible:
		area_2d.monitoring = false
	else:
		area_2d.monitoring = true
	if dead_end.player:
		dead_end.player.position = door_right.position - Vector2(30,0)
		dead_end.player.animation.play("IDLESIDE")
		dead_end.player.animation.flip_h = true
