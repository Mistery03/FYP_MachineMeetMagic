class_name PotionMakerUI
extends MachineControlUI

##NOTE Assume 0.2 is slowing down the loading bar by 20%
@export var slowMultiplier:float = 0.2

@export_category("Progressbar Setting")
@export var progressbar:TextureProgressBar

@export_category("Machine Mana Bar Settings")
@export var machine_mana_bar:TextureProgressBar

@export_category("Material Crafting Recipe")
@export var materialContainer:MaterialRecipeControl

@onready var brew_btn = $brewBTN
@onready var area_of_pressing = $AreaOfPressing

var isBrewPressed:bool = false
var valueInPercentage:float = 0
var timeToProgress:float = 0

func _ready():
	super()
	progressbar.value = valueInPercentage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isBrewPressed and parentMachine.isSwitchedOn:
		parentMachine.consumeMana(5000 * float(materialContainer.multiplier)/100.00,delta)
		
		valueInPercentage += timeToProgress * delta
		valueInPercentage = clamp(valueInPercentage,0,1)
		
		parentMachine.changeAnimation("Processing")
		
		if valueInPercentage >= 1:
			if result_slot.item:
					result_slot.amount += materialContainer.multiplier
					#materialContainer.resultantData.amount += materialContainer.multiplier
			else:
				result_slot.item = materialContainer.resultantData
				result_slot.amount = materialContainer.multiplier
				#materialContainer.resultantData.amount = materialContainer.multiplier
				
			parentMachine.changeAnimation("End")
			parentMachine.potion_sprite.texture = materialContainer.resultantData.texture
			isBrewPressed = false
			brew_btn.disabled = false
			valueInPercentage = 0

	progressbar.value = valueInPercentage

	if !isDragging:
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			whenInventorySlotIsNotEmpty()

func _on_brew_btn_pressed():
	if materialContainer.ingredients and !result_slot.item or result_slot.item == materialContainer.resultantData:
		for ingredient in materialContainer.ingredients:
			if ingredient and materialContainer.isMeetCraftingRequirement and  parentMachine.isSwitchedOn and !power_switch.disabled:
				parentMachine.player.inventory_manager.remove(ingredient.item,materialContainer.required_amount)

				timeToProgress = slowMultiplier *  abs(1.0 - (float(materialContainer.multiplier)/100.00))
				
				brew_btn.disabled = true
				isBrewPressed = true

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			isMousePressed = true

		else:
			isMousePressed = false

		if event.is_action_pressed("ACTION"):
			area_of_pressing.mouse_filter = Control.MOUSE_FILTER_IGNORE
		elif event.is_action_pressed("ACTION2"):
			area_of_pressing.mouse_filter = Control.MOUSE_FILTER_STOP

func _on_area_of_pressing_gui_input(event):
	if event.is_action_pressed("ACTION2"):
		inventoryHandler.removeItem(1,get_global_mouse_position())
