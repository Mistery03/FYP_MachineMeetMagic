extends TileMap

@export var ID:int = 128

@onready var door_up = $DoorUp

@onready var dead_end = $"../.."

func _ready():
	await get_tree().create_timer(0.1).timeout
	if dead_end.player:
		dead_end.player.position = door_up.position + Vector2(0,30)
		#dead_end.player.animation.play("WALKFRONT")
