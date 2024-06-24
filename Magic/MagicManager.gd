class_name MagicManager
extends Node

@export var magicInventory:Control
@export var magicGridInventory:Control #OPTIONAL
@export var magicHUD:Control
@export var magic_tree_ui:Control
@export var magicData:MagicData
@export var staff:Node #need to change later
const IGNIS_NORMAL_ATTACK = preload("res://Magic/IgnisNormalAttack.tscn")
var mousePos:Vector2
var player:Player

func init(player:Player):
	self.player = player
	self.mousePos = player.mousePos
	
	
func _process(delta):
	#read data
	#check which magic been unlock(magic skill tree)
	pass
	
	
func _input(event):
	if event is InputEventMouseButton:
		print("input mouse")
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("mouse button left")
			normalAttack()
			print("unlocked: ", magicData.isUnlocked)
	pass

func trackposition():
	#check mouse position
	pass
	
func normalAttack():
	var magicScene = IGNIS_NORMAL_ATTACK.instantiate()
	get_parent().add_child(magicScene)
	#call trackposition
	#play animation, call ignisNormalAttack?
	#staff call this
	
	
	pass
	
