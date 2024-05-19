class_name PowerGeneratorUI
extends Control

@export var maxValue:float = 100
@export var inventoryHandler:InventoryHanlder

@onready var fuel_slot = $FuelSlot

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var status_bar = $StatusBar
@onready var fuel_burning = $FuelBurning

@export var debugInventory:Array[MaterialData]
@export var debugMaxSlot:int


var currValue:float = 100
var player:Player

var isDragging:bool = false
var gridMousePos:Vector2i

var currItem:Panel

func _ready():
	fuel_burning.value = currValue
	fuel_burning.max_value = maxValue
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(isDragging)
	fuel_burning.value = currValue
	
	if inventoryHandler:
		if player:
			inventoryHandler.playerInventory = player.inventory
			inventoryHandler.maxInventorySlot = player.maxInventorySize
		else:
			inventoryHandler.playerInventory = debugInventory
			inventoryHandler.maxInventorySlot = debugMaxSlot
	
	if !isDragging:
		##@WARNING Does not take account if the inventory slots are different size to the machine slot (in this file fuel_slot)
		gridMousePos = Vector2i(get_global_mouse_position()/fuel_slot.custom_minimum_size)
		if gridMousePos == fuel_slot.getSlotPosition():
				if fuel_slot.item ==  null:
					isDragging = false
					fuel_slot.item = inventoryHandler.currSlot.item
					fuel_slot.amount = inventoryHandler.currSlot.amount
					fuel_slot.item_texture.global_position = fuel_slot.border.global_position 
					fuel_slot.label.global_position =fuel_slot.border.global_position + Vector2(80,60)
					inventoryHandler.currSlot = null
					inventoryHandler.removeItem(fuel_slot.item,fuel_slot.amount)


func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())
