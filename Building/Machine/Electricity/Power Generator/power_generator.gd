class_name PowerGenerator
extends Machine

@export var machineUI:Control
@export var manaPerSecond:float
@export var burnPerSecond:float

@onready var animation = $Animation

var isManaProduced:bool
var machineList:Array = []
var wireList:Array = []
var withinWireList:Array = []

var currManaProduced:float

var accumulativePerctange:float = 0
var accumulativeMaxPerctange:float = 0

var accumulativeMachineMaxCapacity = 0
var isCalculationsDone:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("NoPower")
	await get_tree().create_timer(0.1).timeout
	machineUI.player = player
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isThereFuel:
		if machineUI.power_switch.button_pressed:
			if withinWireList.size() >0:
				for machine in withinWireList:
					if !machine is Battery:
						accumulativeMaxPerctange += machine.maxPercentage
						print(accumulativeMaxPerctange)
						print(accumulativePerctange)
					
						accumulativePerctange += machine.percentage
						
						
			if accumulativePerctange < accumulativeMaxPerctange:
				changeAnimation("Processing")
				machineUI.status_bar.tint_progress = Color.GREEN
				isSwitchedOn = true
				isManaProduced = true
						
		else:
			changeAnimation("idle")
			machineUI.status_bar.tint_progress = Color.YELLOW
			isSwitchedOn = false
			isManaProduced = false
	else:
		changeAnimation("NoPower")
		machineUI.status_bar.tint_progress = Color.RED
		isSwitchedOn = false
		isManaProduced = false
	
	if isSwitchedOn:
		machineUI.burnDisplay(delta)
	
	for machine in withinWireList:
		if is_instance_valid(machine):
			machine.isThereFuel = isManaProduced
		if isManaProduced:
			machine.currMana += machineUI.fuel_slot.item.burnPerSecond * delta
			if !machine is Battery:
				machine.fillManaCapacity(machineUI.fuel_slot.item.burnPerSecond,delta)
		
func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if machineUI.debugMode and !player:
			if event.is_action_pressed("ACTION"):
				machineUI.visible = true
				if machineUI.inventoryHandler.slotList.size() > 0:
					machineUI.inventoryHandler.update_slots()
			
		if player:
			if event.is_action_pressed("ACTION"):
				if !player.isBuildMode:
					machineUI.visible = true
					##The checks for when slotList is not defined
					if machineUI.inventoryHandler.slotList.size() > 0:
						machineUI.inventoryHandler.update_slots()
					
					player.itemHUDPlaceholder.visible = false
					player.isMachineUI = true
	
		

func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false
			if player:
				player.itemHUDPlaceholder.visible = true
				player.isPressable = false
				player.isMachineUI = false
				machineUI.inventoryHandler.convertSlotListToInventoryData()
				await get_tree().create_timer(0.1).timeout
				player.isPressable = true

			
			
		

func changeAnimation(animationName:String):
	animation.play(animationName.to_pascal_case())
	machineUI.machine_animation.play(animationName.to_pascal_case())
	
	
func accumulateMachineMaxCapacity():
	accumulativeMachineMaxCapacity = 0
	if withinWireList.size() > 0 and !isCalculationsDone:
		for machine in withinWireList:
			if !machine is Battery:
				accumulativeMachineMaxCapacity += machine.maxMana
		
		print(accumulativeMachineMaxCapacity)	
		isCalculationsDone = true

