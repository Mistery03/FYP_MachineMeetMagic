extends Control

@export var player:Player

@export var potion_inventory:Control
@onready var grid_container = $GridContainer

var gridList:Array = []
var potionList:Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gridList = grid_container.get_children()
	potionList.clear()
	if potion_inventory:
		for potionSlot in gridList:
			potionSlot.potionInventory = potion_inventory
			potionList.append(potionSlot.potionData)
	
	#print(potionList)


