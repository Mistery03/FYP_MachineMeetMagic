class_name Extractor
extends Machine

@export var machineUI:Control


@onready var animation = $Animation

const MIN_MANA_THRESHOLD: float = 0.0001


# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("IDLE")
	machineUI.machine_mana_bar.max_value = maxMana
	await get_tree().create_timer(0.1).timeout
	machineUI.player = player
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currMana = clamp(currMana,0,maxMana)
	percentage = currMana/maxMana *100
	
	if isThereFuel:
		machineUI.power_switch.disabled = false	
		fillManaCapacity(delta)
	else:
		if currMana <= 0:
			machineUI.power_switch.disabled = true
			changeAnimation("IDLE")
		
	if  currMana > 0:
		if machineUI.power_switch.button_pressed:
			isSwitchedOn = true
		else:
			changeAnimation("IDLE")
			isSwitchedOn = false
		
	if isSwitchedOn and currMana > 0:
		consumeMana(delta)
		
	if isSwitchedOn and machineUI.material_slot.item and machineUI.fuel_slot.item:
		changeAnimation("Processing")
		machineUI.processDisplay(delta)


func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if machineUI.debugMode:
			if event.is_action_pressed("ACTION"):
				machineUI.visible = true
				if machineUI.inventoryHandler.slotList.size() > 0:
					machineUI.inventoryHandler.update_slots()
			
		if player:
			if event.is_action_pressed("ACTION"):
				if !player.isBuildMode:
					machineUI.visible = true
					if machineUI.inventoryHandler.slotList.size() > 0:
						machineUI.inventoryHandler.update_slots()
					
						player.itemHUDPlaceholder.visible = false
						player.isMachineUI = true


func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false
			machineUI.inventoryHandler.update_slots()
			player.itemHUDPlaceholder.visible = true
			player.isPressable = false
			player.isMachineUI = false

func changeAnimation(animationName:String):
	animation.play(animationName.to_pascal_case())
	machineUI.machine_animation.play(animationName.to_pascal_case())

func fillManaCapacity(delta:float):
	currMana+= manaConsumptionPerSecond * delta
	machineUI.machine_mana_bar.currValue = currMana

#To be used in process function
func consumeMana(delta:float): 
	currMana -= manaConsumptionPerSecond * delta
	if percentage <= MIN_MANA_THRESHOLD:
		currMana = 0
	machineUI.machine_mana_bar.currValue = currMana


