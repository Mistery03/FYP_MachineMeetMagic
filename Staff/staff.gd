class_name Staff
extends Node2D

@export var originalPos:Vector2 = Vector2(10,0)
@export var customAnimation:AnimationPlayer
@onready var animation = $Animation
@onready var melee_hitbox = $Animation/sword/meleeHitbox
@export var magicManager:Node
@export var player:Player
#var isEquipped:bool
var mousePos
var staffMana:float

var magicData: MagicData


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	#customAnimation.play("CUTTING")
	#position = originalPos
	#customAnimation.play("RESET")
func _input(event):
	#if player.isStaffEquipped:
	#if player.isMagicAvailable:
	if event is InputEventMouseButton:
		print("input mouse")
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("mouse button left")
			magicManager.normalAttack()



