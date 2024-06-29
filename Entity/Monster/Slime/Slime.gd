class_name Slime
extends Entity

@export var collision_box:Area2D
@export var spawnSFX:AudioStreamPlayer2D
@export var damagePoint:float = 10
@export var localLevel:Node2D
@export var chaseSpeed:float = 6000

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
	add_to_group("Separable")


