class_name ExtractorUI
extends MachineControlUI


@export var resultedItem:MaterialData


@export_category("Fuelbar Settings")
@export var maxValue:float = 100

@export_category("Machine Mana Bar Settings")
@export var machine_mana_bar:TextureProgressBar

#@onready var machine_mana_bar = $MachineManaBar
@onready var progress_bar = $ProgressBar

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
	
	processMaterial()
	
	
	if fuel_slot.item :
		if fuel_slot.amount > 0:
			if fuel_slot.fuelDurability <= 0:
				fuel_slot.amount -= 1

				fuel_slot.fuelDurability = fuel_slot.item.durability					
		else:
			fuel_slot.item = null
		
	
	##@WARNING Does not take account if the inventory slots are different size to the machine slot (in this file fuel_slot)
	gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)
	
	if !isDragging:
		if gridMousePos == fuel_slot.getSlotPosition():
			whenFuelSlotIsEmpty()
			whenFuelSlotIsNotEmpty()
		if gridMousePos == material_slot.getSlotPosition():
			whenMaterialSlotIsEmpty()
			whenMachineSlotIsNotEmpty()
		
					
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			whenInventorySlotIsEmptyFromFuelSlot()
			whenInventorySlotIsNotEmpty()	
			whenInventorySlotIsEmptyFromMaterialSlot()
			
			#if inventoryHandler.currSlot:
				#inventoryHandler.swap(inventoryHandler.currSlot.item,inventoryHandler.currSlot.amount,get_global_mouse_position())
			
			#removeItemFromFuelSlotUI()
			#removeItemFromMaterialSlotUI()
	whenFuelSlotIsEmptyMouseShortcut()
	whenFuelSlotIsNotEmptyMouseShortcut()

	whenMaterialSlotIsEmptyMouseShortcut()
	whenMaterialSlotIsNotEmptyMouseShortcut()
	
	fuelToInventoryShortcutFromFuelSlot()
	fuelToInventoryShortcutFromMaterialSlot()
	
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
	if material_slot.item == null:
		currLoadingValue  = 0
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
			#if material_slot.item == null or material_slot.item == currSlot.item: 
				if Input.is_action_just_pressed("AUTOLOADINITEM"):
					isDragging = false
					##NOTE To prevent item spawning in the world
					inventoryHandler.isForExternalSlot = true
					##Assign the item and amount
					material_slot.item = currSlot.item
					material_slot.amount = currSlot.amount
					##@NOTE resets to it's original position
					material_slot.item_texture.global_position = material_slot.border.global_position 
					material_slot.label.global_position =material_slot.border.global_position + Vector2(80,60)
					##@NOTE resets to it's original position
					currSlot.item_texture.global_position = currSlot.border.global_position
					currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
					
					##Refer to the function in playerInventoryHandler
					inventoryHandler.removeItem(currSlot.amount,currSlot.global_position)
			
					##@NOTE to prevent duplication
					currSlot.item = null
					currSlot = null
					
func whenMaterialSlotIsNotEmptyMouseShortcut():
	if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot:
			if currSlot.item:
				if currSlot.item ==material_slot.item:
					if material_slot.item:##Checks if there fuel item (variable is same as currFuelItem)
						if Input.is_action_just_pressed("AUTOLOADINITEM"):
							isDragging = false
							if inventoryHandler.currSlot:##Checks for null
								if material_slot.item == inventoryHandler.currSlot.item:
									var availableSpace = MAXSTACKSIZE -material_slot.amount
					
									if inventoryHandler.currSlot.amount <= availableSpace:
										## If the current slot amount can fit in the available space
										fuel_slot.amount += inventoryHandler.currSlot.amount
										inventoryHandler.currSlot.item = null
										inventoryHandler.currSlot.amount = 0
									else:
										fuel_slot.amount += availableSpace
										inventoryHandler.currSlot.amount -= availableSpace
									
									##@NOTE resets to it's original position
									fuel_slot.item_texture.global_position =material_slot.border.global_position 
									fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
									
									##@NOTE resets to it's original position
									inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
									inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
									
									if inventoryHandler.currSlot.amount == 0:
										inventoryHandler.currSlot = null	
								elif inventoryHandler.currSlot.item !=material_slot.item:
									isDragging = false
														
func whenMaterialSlotIsEmpty():
	if material_slot.item ==  null:##Checks if there no fuel item (variable is same as currFuelItem)
		isDragging = false
		##Checks two thing the item from the inventory and is the item type fuel
		if inventoryHandler.currSlot:
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

func whenMachineSlotIsNotEmpty():
	if material_slot.item:##Checks if there fuel item (variable is same as currFuelItem)
		isDragging = false
		if inventoryHandler.currSlot:##Checks for null
			if material_slot.item == inventoryHandler.currSlot.item:
				var availableSpace = MAXSTACKSIZE - material_slot.amount
				if inventoryHandler.currSlot.amount <= availableSpace:
					## If the current slot amount can fit in the available space
					material_slot.amount += inventoryHandler.currSlot.amount
					
					## Reset the current slot
					inventoryHandler.currSlot.item = null
					inventoryHandler.currSlot.amount = 0
				else:
					## If there is overflow
					material_slot.amount += availableSpace
					inventoryHandler.currSlot.amount -= availableSpace
				
				
				##@NOTE resets to it's original position
				material_slot.item_texture.global_position = material_slot.border.global_position 
				material_slot.label.global_position =material_slot.border.global_position + Vector2(80,60)
				
				##@NOTE resets to it's original position
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				
				##@NOTE to prevent duplication
				if inventoryHandler.currSlot.amount == 0:
					inventoryHandler.currSlot = null


func whenInventorySlotIsEmptyFromMaterialSlot():
	if currMaterialSlotItem :##Checks if there fuel item same as (variable is same as fuel_slot.item)
		isDragging = false
		inventoryHandler.insertItemAtInventorySlot(get_global_mouse_position(),material_slot.item, material_slot.amount)
	
		material_slot.item = null
		currMaterialSlotItem = null

func fuelToInventoryShortcutFromMaterialSlot():
	if material_slot.item:
		if material_slot.isMousePressed:
			isDragging = false
			inventoryHandler.insertItem(material_slot.item,material_slot.amount)
			material_slot.item = null
			material_slot.isMousePressed = false

func _on_area_of_pressing_gui_input(event):
	if event.is_action_pressed("ACTION2"):
		inventoryHandler.removeItem(1,get_global_mouse_position())
