class_name PowerGeneratorUI
extends MachineControlUI


@export_category("Fuel Bar Progress")
##Used for Fuel progress bar
@export var maxValue:float = 100


@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var status_bar = $StatusBar
@onready var fuel_burning = $FuelBurning
@onready var area_of_pressing = $AreaOfPressing


var currValue:float = 100

func _ready():
	super()
	fuel_burning.value = currValue
	fuel_burning.max_value = maxValue
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currValue <= 0:
		if fuel_slot.item and fuel_slot.amount > 0:
			currValue = maxValue
			fuel_slot.fuelDurability -= 1
			if fuel_slot.fuelDurability <= 0:
				fuel_slot.amount -= 1
				if fuel_slot.amount > 0:
					fuel_slot.fuelDurability = fuel_slot.item.durability
				else:
					fuel_slot.item = null
		else:
			fuel_slot.item = null

	fuel_burning.value = currValue
	
	fuelSlotLogic()
	
	whenFuelSlotIsEmptyMouseShortcut()
	whenFuelSlotIsNotEmptyMouseShortcut()
	
	##Fuel to Inventory shortcut
	fuelToInventoryShortcut()
	
	#if inventoryHandler.currSlot:
		#print(inventoryHandler.currSlot.amount)
	
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

func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())

func burnDisplay(delta):
	if fuel_slot.item:
		currValue -= fuel_slot.item.burnPerSecond * delta
	currValue = clamp(currValue, 0, maxValue)

func fuelSlotLogic():
	##@WARNING Does not take account if the inventory slots are different size to the machine slot 
	gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)

	if !isDragging:
		##From inventory to fuel slot
		if gridMousePos == fuel_slot.getSlotPosition():
			whenFuelSlotIsEmpty()
			whenFuelSlotIsNotEmpty()			
		
		##From fuel slot to inventory
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			whenInventorySlotIsEmptyFromFuelSlot()
			whenInventorySlotIsNotEmpty()	
			
func whenFuelSlotIsEmpty():
		if fuel_slot.item ==  null:##Checks if there no fuel item (variable is same as currFuelItem)
			isDragging = false
			##Checks two thing the item from the inventory and is the item type fuel
			if inventoryHandler.currSlot and inventoryHandler.currSlot.item.type == "Fuel":
				
				##NOTE To prevent item spawning in the world
				inventoryHandler.isForExternalSlot = true
				
				##Assign the item and amount
				fuel_slot.item = inventoryHandler.currSlot.item
				fuel_slot.amount = inventoryHandler.currSlot.amount
				
				##@NOTE resets to it's original position
				fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
				fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
				##@NOTE resets to it's original position
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				
				##Refer to the function in playerInventoryHandler
				inventoryHandler.removeItem(inventoryHandler.currSlot.amount,inventoryHandler.currSlot.global_position)
				
				##@NOTE to prevent duplication
				inventoryHandler.currSlot.item = null
				inventoryHandler.currSlot = null

func whenFuelSlotIsNotEmpty():
	if fuel_slot.item:##Checks if there fuel item (variable is same as currFuelItem)
		isDragging = false
		if inventoryHandler.currSlot:##Checks for null
			if fuel_slot.item == inventoryHandler.currSlot.item:
				fuel_slot.amount += inventoryHandler.currSlot.amount
				
				##@NOTE resets to it's original position
				fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
				fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
				
				##@NOTE resets to it's original position
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				
				##@NOTE to prevent duplication
				inventoryHandler.currSlot.item = null
				inventoryHandler.currSlot = null

	




	

func _on_area_of_pressing_gui_input(event):
	if event.is_action_pressed("ACTION2"):
		inventoryHandler.removeItem(1,get_global_mouse_position())
