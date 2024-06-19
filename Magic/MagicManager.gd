class_name MagicMachine
extends Node

@export var magicInventory:Control
@export var magicGridInventory:Control #OPTIONAL
@export var magicHUD:Control
@export var magic_tree_ui:Control

@export var staff:Node #need to change later

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
	pass

func normalAttack():
	#follow mouse position, when click then play attack animation
	#need to pass mouse position as parameter from staff to call
	pass
	
	

