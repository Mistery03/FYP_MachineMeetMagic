class_name Extractor
extends Machine

const MIN_MANA_THRESHOLD: float = 0.0001

# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("IDLE")
	machineUI.machine_mana_bar.max_value = maxMana
	super()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currMana = clamp(currMana,0,maxMana)
	percentage = currMana/maxMana *100
	
	if isThereFuel:
		machineUI.power_switch.disabled = false	
		#fillManaCapacity(delta)
	else:
		if currMana <= 0:
			machineUI.power_switch.disabled = true
			changeAnimation("IDLE")
			
	if machineUI.power_switch.button_pressed:
		isSwitchedOn = true
	else:
			changeAnimation("IDLE")
			isSwitchedOn = false
				
	if isSwitchedOn:
		if machineUI.material_slot.item and machineUI.fuel_slot.item:
			changeAnimation("Processing")
			machineUI.processDisplay(delta)
		elif machineUI.material_slot.item and currMana > 0:
			changeAnimation("Processing")
			machineUI.processDisplay(delta)
			consumeMana(machineUI.material_slot.item.burnPerSecond,delta)	
	



func fillManaCapacity(manaConsumptionPerSecond,delta:float):
	currMana+= manaConsumptionPerSecond * delta
	machineUI.machine_mana_bar.currValue = currMana

#To be used in process function
func consumeMana(manaConsumptionPerSecond,delta:float): 
	currMana -= manaConsumptionPerSecond * delta
	if percentage <= MIN_MANA_THRESHOLD:
		currMana = 0
	machineUI.machine_mana_bar.currValue = currMana


