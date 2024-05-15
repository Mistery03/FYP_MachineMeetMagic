class_name PotionManager
extends Node

@export var potionInventory:Control
@export var potionGridInventory:Control
@export var potionHUD:Control
var potionData:PotionData


func _process(delta):
	if potionData:
		var potionAmount = potionInventory.getPotionAmount(potionData)

		potionHUD.potion_amount.text = str(potionAmount)
	
		
func _input(event):

	if potionData:
		var potionAmount = potionInventory.getPotionAmount(potionData)
		#potionHUD.potion_amount.text = str(potionAmount)
		print(potionAmount)

		if potionAmount <= 0:
			potionHUD.darkened.visible = true
			print("emptied")
			
		else:
			potionHUD.darkened.visible = false
			if event.is_action_pressed("DRINKPOTION"):
				potionInventory.decreasePotionAmount(potionData)
				potionGridInventory.decreasePotionAmount(potionData)
				print("drank")
				
		
	
	
		
	
	
		
	



