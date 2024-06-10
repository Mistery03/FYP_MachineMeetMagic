class_name PotionManager
extends Node

@export var inventoryUI:Control
@export var potionHUD:Control
var potionData:PotionData


func _process(delta):
	if potionData:
		var potionAmount = inventoryUI.potion_inventory.getPotionAmount(potionData)

		potionHUD.potion_amount.text = str(potionAmount)
	
		
func _input(event):

	if potionData:
		var potionAmount = inventoryUI.potion_inventory.getPotionAmount(potionData)
		#potionHUD.potion_amount.text = str(potionAmount)
		print(potionAmount)

		if potionAmount <= 0:
			potionHUD.darkened.visible = true
			print("emptied")
			
		else:
			potionHUD.darkened.visible = false
			if event.is_action_pressed("DRINKPOTION"):
				inventoryUI.potion_inventory.decreasePotionAmount(potionData)
				inventoryUI.potion_grid_container_player.decreasePotionAmount(potionData)
				print("drank")
			
		
	
	
		
	
	
		
	



