class_name BlueSlime
extends Slime

var spawnPoint = position  # Define the spawn point
var currentDirection = Vector2(1, 0)  # Initial direction
var player:Player
var originalPos = Vector2.ZERO
var leap_direction = Vector2.ZERO
var hasCollidedWithPlayer:bool = false
@onready var collision_box = $CollisionBox


func _ready():
	currHealth = maxHP
	spawnPoint = position
	stateController.init(self,animation,moveComponent)
	await get_tree().create_timer(0.5).timeout

	

func _process(delta):
	print("Slime HP: ",currHealth)
	

	
