class_name Machine
extends Node

@export_category("Machine Settings")
@export var machineUI:Control
@export var animation:AnimatedSprite2D

@export_category("Machine Logic")
@export var isThereFuel:bool
@export var manaConsumptionPerSecond:float
@export var maxMana:float


var machine:Machine 
var next:Machine = null
var player:Player


var isSwitchedOn:bool

var currMana:float
var percentage:float
@onready var maxPercentage:float = maxMana/maxMana * 100

func _ready():
	await get_tree().create_timer(0.1).timeout
	machineUI.player = player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("test")

func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if machineUI.debugMode and !player:
			if event.is_action_pressed("ACTION"):
				machineUI.visible = true

		if player:
			if event.is_action_pressed("ACTION"):
				if !player.isBuildMode:
					machineUI.visible = true
					##The checks for when slotList is not defined
					if machineUI.inventoryHandler:
						if machineUI.inventoryHandler.slotList.size() > 0:
							machineUI.inventoryHandler.update_slots()
					
					player.itemHUDPlaceholder.visible = false
					player.playerHUD.visible = false
					player.isMachineUI = true

func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false
			if player:
				player.itemHUDPlaceholder.visible = true
				player.playerHUD.visible = true
				player.isPressable = false
				player.isMachineUI = false
				if machineUI.inventoryHandler:
					machineUI.inventoryHandler.convertSlotListToInventoryData()
				await get_tree().create_timer(0.1).timeout
				player.isPressable = true

func changeAnimation(animationName:String):
	animation.play(animationName.to_pascal_case())
	machineUI.machine_animation.play(animationName.to_pascal_case())
