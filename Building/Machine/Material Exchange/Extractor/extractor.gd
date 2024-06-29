class_name Extractor
extends Machine

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






func _on_interectable_input_event(viewport, event, shape_idx):
	super(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		if player and machineUI.result_slot.item:
			if event.is_action_pressed("ACTION2"):
				pickup_sfx.play()
				player.MagicEssenceCurrency +=machineUI.result_slot.amount
				machineUI.result_slot.item = null
				machineUI.result_slot.amount = 0
