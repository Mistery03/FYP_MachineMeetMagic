class_name PowerGeneratorUI
extends Control

@export var parentMachine:Machine

@export var maxValue:float = 100
@export var inventoryHandler:InventoryHanlder

@onready var fuel_slot = $FuelSlot

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var status_bar = $StatusBar
@onready var fuel_burning = $FuelBurning

@export var debugInventory:Array[SlotData]
@export var debugItem:MaterialData
@export var debugMaxSlot:int
@export var debugMode:bool = false


var currValue:float = 100
var player:Player

var isDragging:bool = false
var gridMousePos:Vector2i
var slotMousPos:Vector2i

var currFuelItem:Panel
var prevSlot:Panel

var isMousePressed:bool

func _ready():
	fuel_burning.value = currValue
	fuel_burning.max_value = maxValue
	await get_tree().create_timer(0.2).timeout
	inventoryHandler.init(player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inventoryHandler:
		if player:
			inventoryHandler.playerInventory = player.inventory
			inventoryHandler.maxInventorySlot = player.maxInventorySize
		else:
			if debugMode:
				inventoryHandler.playerInventory = debugInventory
				inventoryHandler.maxInventorySlot = debugMaxSlot
		

	if currValue <= 0:
		currValue = maxValue
		if fuel_slot.item and fuel_slot.amount-1 > 0:
			fuel_slot.amount -= 1
		else:
			fuel_slot.item = null
	
	fuel_burning.value = currValue
	
	
	##@WARNING Does not take account if the inventory slots are different size to the machine slot (in this file fuel_slot)
	gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)

	if !isDragging:
		if gridMousePos == fuel_slot.getSlotPosition():
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
					
	
		if inventoryHandler.globalMousePosToLocalGrid(get_global_mouse_position()) in inventoryHandler.getSlotPositions():
			if inventoryHandler.currSlot:
				inventoryHandler.swap(inventoryHandler.currSlot.item,inventoryHandler.currSlot.amount,get_global_mouse_position())
			
			if currFuelItem :
				isDragging = false
				var currSlot = inventoryHandler.getSlotBasedOnPosition(get_global_mouse_position())
				if currSlot.item == null:
					currSlot.item = fuel_slot.item
					currSlot.amount = fuel_slot.amount
					currSlot.item_texture.global_position = currSlot.border.global_position
					currSlot.label.global_position = currSlot.border.global_position + Vector2(80,60)
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
					

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			isMousePressed = true
		else:
			isMousePressed = false
		
		
		if event.is_action_pressed("ACTION2"):
			inventoryHandler.removeItem(1,get_global_mouse_position())
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
