class_name BlueSlime
extends Slime

var spawnPoint = position  # Define the spawn point
var currentDirection = Vector2(1, 0)  # Initial direction

func _ready():
	spawnPoint = position
	print(spawnPoint)
	stateController.init(self,animation,moveComponent)
