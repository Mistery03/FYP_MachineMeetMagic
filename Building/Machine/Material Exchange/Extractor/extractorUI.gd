class_name ExtractorUI
extends MachineControlUI


@export var resultedItem:MaterialData


@export_category("Fuelbar Settings")
@export var maxValue:float = 100

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var machine_mana_bar = $MachineManaBar
@onready var progress_bar = $ProgressBar


@onready var material_slot = $MaterialSlot
@onready var result_slot = $ResultSlot
@onready var area_of_pressing = $AreaOfPressing

var currValue:float = 100
var currLoadingValue:float = 0


var currMaterialSlotItem:Panel


func _ready():
	super()
	progress_bar.value = currLoadingValue
	progress_bar.max_value = maxValue
	if debugMode:
		power_switch.disabled = !debugMode
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##@WARNING Does not take account if the inventory slots are different size to the machine slot (in this file fuel_slot)
	gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)
	
	processMaterial()
	
	if fuel_slot.item and fuel_slot.amount > 0:
		if fuel_slot.fuelDurability <= 0:
			fuel_slot.amount -= 1
			fuel_slot.fuelDurability = fuel_slot.item.durability					
	else:
		fuel_slot.item = null
		
	whenFuelSlotIsEmptyMouseShortcut()
	whenFuelSlotIsNotEmptyMouseShortcut()
	whenMaterialSlotIsEmptyMouseShortcut()
	fuelToInventoryShortcut()
	
	if !isDragging:
		if gridMousePos == fuel_slot.getSlotPosition():
			fuelSlotLogic()
		if gridMousePos == material_slot.getSlotPosition():
			materialSlotLogic()
					
	
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			whenInventorySlotIsEmptyFromFuelSlot()
			whenInventorySlotIsNotEmpty()
			#if inventoryHandler.currSlot:
				#inventoryHandler.swap(inventoryHandler.currSlot.item,inventoryHandler.currSlot.amount,get_global_mouse_position())
			
			#removeItemFromFuelSlotUI()
			#removeItemFromMaterialSlotUI()

func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())

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
		
	if debugMode:
		if event is InputEventKey:
			if event.is_action_pressed("MOVERIGHT"):
				inventoryHandler.insertItem(debugItem,10)	
			if event.is_action_pressed("ui_down"):
				inventoryHandler.convertSlotListToInventoryData()
				#inventoryHandler.update_slots()

func fuelSlotLogic():
	if fuel_slot.item ==  null:
		isDragging = false
		if inventoryHandler.currSlot and inventoryHandler.currSlot.item.type == "Fuel":
			inventoryHandler.isForExternalSlot = true
			fuel_slot.item = inventoryHandler.currSlot.item
			fuel_slot.amount = inventoryHandler.currSlot.amount
			fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
			fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
			
			inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
			inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
			inventoryHandler.removeItem(inventoryHandler.currSlot.amount,inventoryHandler.currSlot.global_position)
			
			inventoryHandler.currSlot.item = null
			inventoryHandler.currSlot = null
					
					
	if fuel_slot.item:
		if inventoryHandler.currSlot:
			if fuel_slot.item == inventoryHandler.currSlot.item:
				fuel_slot.amount += inventoryHandler.currSlot.amount
				fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
				fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				inventoryHandler.currSlot.item = null
				inventoryHandler.currSlot = null

func materialSlotLogic():
	if material_slot.item ==  null:
		isDragging = false
		if inventoryHandler.currSlot:
			inventoryHandler.isForExternalSlot = true
			material_slot.item = inventoryHandler.currSlot.item
			material_slot.amount = inventoryHandler.currSlot.amount
			material_slot.item_texture.global_position = material_slot.border.global_position 
			material_slot.label.global_position =material_slot.border.global_position + Vector2(80,60)
			
			inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
			inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
			if inventoryHandler.removeItem(inventoryHandler.currSlot.amount,inventoryHandler.currSlot.global_position):
			
				inventoryHandler.currSlot.item = null
				inventoryHandler.currSlot = null
					
					
	if material_slot.item:
		if inventoryHandler.currSlot:
			if material_slot.item == inventoryHandler.currSlot.item:
				material_slot.amount += inventoryHandler.currSlot.amount
				material_slot.item_texture.global_position = material_slot.border.global_position 
				material_slot.label.global_position =material_slot.border.global_position + Vector2(80,60)
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				inventoryHandler.currSlot.item = null
				inventoryHandler.currSlot = null

func removeItemFromFuelSlotUI():
	if currFuelItem :
		isDragging = false
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot.item == null:
			currSlot.item = fuel_slot.item
			currSlot.amount = fuel_slot.amount
			currSlot.item_texture.global_position = currSlot.border.global_position
			currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
			if player:
				for index in len(player.inventory):
					if player.inventory[index] == null:
						var slotToBeAdded = SlotData.new()
						slotToBeAdded.item = fuel_slot.item
						slotToBeAdded.amount = fuel_slot.amount
						player.inventory[index] = slotToBeAdded
						break
			fuel_slot.item = null
			
		elif currSlot.item == fuel_slot.item:
			currSlot.amount += fuel_slot.amount
			currSlot.item_texture.global_position = currSlot.border.global_position
			currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
			fuel_slot.item = null
		currFuelItem = null

func removeItemFromMaterialSlotUI():
	if currMaterialSlotItem:
		isDragging = false
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot.item == null:
			currSlot.item = material_slot.item
			currSlot.amount = material_slot.amount
			currSlot.item_texture.global_position = currSlot.border.global_position
			currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
			if player:
				for index in len(player.inventory):
					if player.inventory[index] == null:
						var slotToBeAdded = SlotData.new()
						slotToBeAdded.item = material_slot.item
						slotToBeAdded.amount = material_slot.amount
						player.inventory[index] = slotToBeAdded
						break
			material_slot.item = null
			
		elif currSlot.item == material_slot.item:
			currSlot.amount += material_slot.amount
			currSlot.item_texture.global_position = currSlot.border.global_position
			currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
			material_slot.item = null
		currLoadingValue  = 0
		currMaterialSlotItem = null

func burnDisplay(delta):
	if fuel_slot.item:
		currValue -= fuel_slot.item.burnPerSecond * delta
	currValue = clamp(currValue, 0, maxValue)

func processDisplay(delta):
	if material_slot.item:
		currLoadingValue += material_slot.item.burnPerSecond * delta
	currLoadingValue = clamp(currLoadingValue , 0, maxValue)

func processMaterial():
	if currLoadingValue >= 99:
		currLoadingValue  = 0
		if material_slot.item and material_slot.amount-1 > 0:
			material_slot.amount -= 1
			fuel_slot.fuelDurability -= 1	
			produceResult()
		else:
			produceResult()
			material_slot.item = null
					
	progress_bar.value = currLoadingValue 

func produceResult():
	if result_slot.item == null:
		result_slot.item = resultedItem
		result_slot.amount = material_slot.item.magicEssenceAmountResult
	else:
		result_slot.amount += material_slot.item.magicEssenceAmountResult

func whenMaterialSlotIsEmptyMouseShortcut():
	if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot.item:
			if material_slot.item == null:
				if Input.is_action_just_pressed("AUTOLOADINITEM"):
					isDragging = false
					##NOTE To prevent item spawning in the world
					inventoryHandler.isForExternalSlot = true
					##Assign the item and amount
					material_slot.item = inventoryHandler.currSlot.item
					material_slot.amount = inventoryHandler.currSlot.amount
					##@NOTE resets to it's original position
					material_slot.item_texture.global_position = material_slot.border.global_position 
					material_slot.label.global_position =material_slot.border.global_position + Vector2(80,60)
					##@NOTE resets to it's original position
					inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
					inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
					
					##Refer to the function in playerInventoryHandler
					inventoryHandler.removeItem(inventoryHandler.currSlot.amount,inventoryHandler.currSlot.global_position)
			
					##@NOTE to prevent duplication
					inventoryHandler.currSlot.item = null
					inventoryHandler.currSlot = null

func _on_area_of_pressing_gui_input(event):
	if event.is_action_pressed("ACTION2"):
	
	
		inventoryHandler.removeItem(1,get_global_mouse_position())
