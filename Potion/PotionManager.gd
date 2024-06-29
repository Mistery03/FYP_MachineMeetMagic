class_name PotionManager
extends Node

@export var inventoryUI:Control
@export var potionHUD:Control
@export var player:Player

var potionData:PotionData

var current_potion_instance = null
var previous_potion_data = null

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
			
			if potionData != previous_potion_data:
				# If there is an existing potion instance, free it
				if current_potion_instance:
					current_potion_instance.queue_free()
				
				# Instantiate the new potion instance
				current_potion_instance = potionData.scene.instantiate()
				previous_potion_data = potionData  # Update the previous potion data reference
			if event.is_action_pressed("DRINKPOTION"):
				current_potion_instance.execute(player)
				potionData.amount -= 1
				#inventoryUI.potion_inventory.decreasePotionAmount(potionData)
				inventoryUI.potion_grid_container_player.decreasePotionAmount(potionData)
				print("drank")












