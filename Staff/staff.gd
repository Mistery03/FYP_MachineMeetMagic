class_name Staff
extends Node2D

@export var originalPos:Vector2 = Vector2(10,0)
@export var customAnimation:AnimationPlayer
@onready var animation = $Animation
@onready var melee_hitbox = $Animation/sword/meleeHitbox
@export var magicManager:Node
#var isEquipped:bool
var mousePos
var staffMana:float

# Called when the node enters the scene tree for the first time.
func _ready():
	magicManager.normalAttack()
	pass
	#customAnimation.play("CUTTING")
	#position = originalPos
	#customAnimation.play("RESET")



