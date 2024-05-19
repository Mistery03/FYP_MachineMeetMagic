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
	


func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())
