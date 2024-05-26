extends TileMap

@export var ID:int = 131

@onready var door_left = $DoorLeft

@onready var dead_end = $"../.."

func _ready():
	await get_tree().create_timer(0.1).timeout
	if dead_end.player:
		dead_end.player.position = door_left.position + Vector2(30,0)
		dead_end.player.animation.play("IDLESIDE")
