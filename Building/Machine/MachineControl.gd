class_name  MachineControlUI
extends Control

##The parent machine is what this UI is under what machine [Example: if it's power generator then the parent is power generator
@export_category("Machine Setting")
@export var parentMachine:Machine
@export var machine_animation:AnimatedSprite2D

@export_category("Machine Fuel Input")
@export var fuel_slot:FuelSlot

@export_category("Machine Material Input")
@export var material_slot:MaterialSlot
@export var result_slot:ResultSlot

@export_category("Inventory Controller")
@export var inventoryHandler:InventoryHandler

@export_category("Debug Settings")
@export var debugInventory:Array[SlotData]
@export var debugItem:MaterialData
@export var debugMaxSlot:int
@export var debugMode:bool = false

const MAXSTACKSIZE = 99

var player:Player
var gridMousePos:Vector2i
var isDragging:bool = false
var isMousePressed:bool
var currFuelItem:Panel
var prevSlot:Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	inventoryHandler.init(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func whenFuelSlotIsEmptyMouseShortcut():
	if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot.item:
			if currSlot.item.type == "Fuel":
				if fuel_slot.item == null:
					if Input.is_action_just_pressed("AUTOLOADINITEM"):
						isDragging = false
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

func whenFuelSlotIsNotEmptyMouseShortcut():
	if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
		var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
		if currSlot.item:
			if currSlot.item.type == "Fuel":
				if fuel_slot.item:##Checks if there fuel item (variable is same as currFuelItem)
					if Input.is_action_just_pressed("AUTOLOADINITEM"):
						isDragging = false
						if inventoryHandler.currSlot:##Checks for null
							if fuel_slot.item == inventoryHandler.currSlot.item:
								var availableSpace = MAXSTACKSIZE - fuel_slot.amount
				
								if inventoryHandler.currSlot.amount <= availableSpace:
									## If the current slot amount can fit in the available space
									fuel_slot.amount += inventoryHandler.currSlot.amount
									inventoryHandler.currSlot.item = null
									inventoryHandler.currSlot.amount = 0
								else:
									fuel_slot.amount += availableSpace
									inventoryHandler.currSlot.amount -= availableSpace
								
								##@NOTE resets to it's original position
								fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
								fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
								
								##@NOTE resets to it's original position
								inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
								inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
								
								if inventoryHandler.currSlot.amount == 0:
									inventoryHandler.currSlot = null	
							elif inventoryHandler.currSlot.item != fuel_slot.item:
								isDragging = false

func fuelToInventoryShortcutFromFuelSlot():
	if fuel_slot.item:
		if fuel_slot.isMousePressed:
			isDragging = false
			inventoryHandler.insertItem(fuel_slot.item,fuel_slot.amount)
			fuel_slot.item = null
			fuel_slot.isMousePressed = false

func whenInventorySlotIsEmptyFromFuelSlot():
	if currFuelItem :##Checks if there fuel item same as (variable is same as fuel_slot.item)
		isDragging = false
		inventoryHandler.insertItemAtInventorySlot(get_global_mouse_position(),fuel_slot.item, fuel_slot.amount)
	
		fuel_slot.item = null
		currFuelItem = null
		
func whenInventorySlotIsNotEmpty():
	if inventoryHandler.currSlot:
		##NOTE function in playerInventoryHandler
		inventoryHandler.swap(inventoryHandler.currSlot.item,inventoryHandler.currSlot.amount,get_global_mouse_position())

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
				var availableSpace = MAXSTACKSIZE - fuel_slot.amount
				if inventoryHandler.currSlot.amount <= availableSpace:
					## If the current slot amount can fit in the available space
					fuel_slot.amount += inventoryHandler.currSlot.amount
					
					## Reset the current slot
					inventoryHandler.currSlot.item = null
					inventoryHandler.currSlot.amount = 0
				else:
					## If there is overflow
					fuel_slot.amount += availableSpace
					inventoryHandler.currSlot.amount -= availableSpace
				
				
				##@NOTE resets to it's original position
				fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
				fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
				
				##@NOTE resets to it's original position
				inventoryHandler.currSlot.item_texture.global_position = inventoryHandler.currSlot.border.global_position
				inventoryHandler.currSlot.label.global_position = inventoryHandler.currSlot.border.global_position + Vector2(80,60)
				
				##@NOTE to prevent duplication
				if inventoryHandler.currSlot.amount == 0:
					inventoryHandler.currSlot = null
