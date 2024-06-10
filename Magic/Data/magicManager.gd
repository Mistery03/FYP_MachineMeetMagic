class_name MagicMachine
extends Node

@export var magicInventory:Control
@export var magicGridInventory:Control #OPTIONAL
@export var magicHUD:Control 
#var MagicData:MagicData
@export var staff:Node #need to change later
@export var magic_tree_ui:Control
var mousePos:Vector2
var player:Player

func init(player:Player, mousePos:Vector2):
	self.player = player
	self.mousePos = mousePos
	
func _process(delta):
	#read data
	#check which magic been unlock(magic skill tree)
	
	pass
	
	
func _input(event):
	#input to call the skll magic
	#player -> manager -> magicSkill 
	#if the magic is that then use that magicSkill
	
	
	if event.is_action_pressed("CHARACTERSHEET"):
		magic_tree_ui.visible = true
		print("pressed")
		#open ui scene
		pass

func normalAttack():
	#follow mouse position, when click then play attack animation
	#need to pass mouse position as parameter from staff to call
	pass
	
	

