class_name BlueSlime
extends Slime

@export var spawnSFX:AudioStreamPlayer2D

@onready var collision_box = $CollisionBox

var spawnPoint = position  # Define the spawn point
var currentDirection = Vector2(1, 0)  # Initial direction
var player:Player
var originalPos = Vector2.ZERO
var leap_direction = Vector2.ZERO
var hasCollidedWithPlayer:bool = false




func _ready():
	currHealth = maxHP
	spawnPoint = position
	stateController.init(self,animation,moveComponent)
	spawnSFX.play()
	

	

func _process(delta):
	#print("Slime HP: ",currHealth)
	pass
	

	
