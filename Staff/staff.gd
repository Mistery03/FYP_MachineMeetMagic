class_name Staff
extends Node2D

@export var originalPos:Vector2 = Vector2(10,0)
@export var customAnimation:AnimationPlayer
@onready var animation = $Animation
@onready var melee_hitbox = $Animation/sword/meleeHitbox
@export var magicManager:Node
@export var player:Player

@onready var magic_spawn_point = $Animation/MagicSpawnPoint
#var isEquipped:bool
var mousePos
var staffMana:float
var canCast:bool = true
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
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and canCast:
			print("mouse button left")
			magicManager.normalAttack()
			canCast = false
			await get_tree().create_timer(2).timeout
			canCast = true
			



