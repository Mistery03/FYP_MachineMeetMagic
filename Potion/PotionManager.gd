class_name PotionManager
extends Node

@export var potionInventory:Control
@export var potionGridInventory:Control
var potionData:PotionData



func _input(event):
	if event.is_action_pressed("DRINKPOTION"):
		if potionData:
			potionInventory.decreasePotionAmount(potionData)
			potionGridInventory.decreasePotionAmount(potionData)
			print(potionData.name)
	
	
		
	
	
		
	



