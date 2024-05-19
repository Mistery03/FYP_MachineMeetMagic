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
	
	print(potionList)

func decreasePotionAmount(potionData:PotionData):
	for potion in grid_container.get_children():
		if potion.potionData == potionData:
			potion.potionAmount -= 1

func increasePotionAmount(potionData:PotionData):
	for potion in grid_container.get_children():
		if potion.potionData == potionData:
			potion.potionAmount += 1

func getPotionAmount(potionData:PotionData) -> int:
	for potion in grid_container.get_children():
		if potion.potionData == potionData:
			return potion.potionAmount
	
	return 0
