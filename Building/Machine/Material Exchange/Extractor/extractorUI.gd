class_name ExtractorUI
extends Control





@export var maxValue:float = 100


@export var parentMachine:Machine
@export var inventoryHandler:InventoryHandler

@export_category("Debug System")
@export var debugInventory:Array[SlotData]
@export var debugItem:MaterialData
@export var debugMaxSlot:int
@export var debugMode:bool = false

@export var resultedItem:MaterialData

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var machine_mana_bar = $MachineManaBar
@onready var progress_bar = $ProgressBar

@onready var fuel_slot = $FuelSlot
@onready var material_slot = $MaterialSlot
@onready var result_slot = $ResultSlot
@onready var area_of_pressing = $AreaOfPressing

var currValue:float = 100
var currLoadingValue:float = 0
var player:Player

var isDragging:bool = false
var gridMousePos:Vector2i
var slotMousPos:Vector2i

var isMousePressed:bool

var currFuelItem:Panel
var currMaterialSlotItem:Panel
var prevSlot:Panel

func _ready():
	progress_bar.value = currLoadingValue
	progress_bar.max_value = maxValue
	if debugMode:
		power_switch.disabled = !debugMode
	await get_tree().create_timer(0.2).timeout
	inventoryHandler.init(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	##@WARNING Does not take account if the inventory slots are different size to the machine slot (in this file fuel_slot)
	gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)
	
	if inventoryHandler:
		if player:
			inventoryHandler.playerInventory = player.inventory
			inventoryHandler.maxInventorySlot = player.maxInventorySize
		else:
			if debugMode:
				inventoryHandler.playerInventory = debugInventory
				inventoryHandler.maxInventorySlot = debugMaxSlot
	
	if currLoadingValue >= 100:
		currLoadingValue  = 0
		if material_slot.item and material_slot.amount-1 > 0:
			material_slot.amount -= 1
			fuel_slot.fuelDurability -= 1
					
			if result_slot.item == null:
				result_slot.item = resultedItem
				result_slot.amount = 1
			else:
				result_slot.amount += 1
		else:
			if result_slot.item == null:
				result_slot.item = resultedItem
				result_slot.amount = 1
			else:
				result_slot.amount += 1
			material_slot.item = null
					
	progress_bar.value = currLoadingValue 
	
	if fuel_slot.item and fuel_slot.amount > 0:
		if fuel_slot.fuelDurability <= 0:
			fuel_slot.amount -= 1
			fuel_slot.fuelDurability = fuel_slot.item.durability
					
			
	else:
		fuel_slot.item = null
	
	if !isDragging:
		if gridMousePos == fuel_slot.getSlotPosition():
			fuelSlotLogic()
		if gridMousePos == material_slot.getSlotPosition():
			materialSlotLogic()
					
	
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			if inventoryHandler.currSlot:
				inventoryHandler.swap(inventoryHandler.currSlot.item,inventoryHandler.currSlot.amount,get_global_mouse_position())
			
			removeItemFromFuelSlotUI()
			removeItemFromMaterialSlotUI()

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
		currMaterialSlotItem = null

func burnDisplay(delta):
	if fuel_slot.item:
		currValue -= fuel_slot.item.burnPerSecond * delta
	currValue = clamp(currValue, 0, maxValue)

func processDisplay(delta):
	if material_slot.item:
		currLoadingValue += material_slot.item.burnPerSecond * delta
	currLoadingValue = clamp(currLoadingValue , 0, maxValue)


func _on_area_of_pressing_gui_input(event):
	if event.is_action_pressed("ACTION2"):
	
	
		inventoryHandler.removeItem(1,get_global_mouse_position())
