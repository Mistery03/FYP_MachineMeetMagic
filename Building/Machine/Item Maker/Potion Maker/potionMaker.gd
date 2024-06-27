class_name PotionMaker
extends Machine


func _ready():
	changeAnimation("IDLE")
	machineUI.machine_mana_bar.max_value = maxMana
	super()
	
func _process(delta):
	if isThereFuel:
		machineUI.power_switch.disabled = false	
		#fillManaCapacity(delta)
	else:
		if currMana <= 0:
			machineUI.power_switch.disabled = true
			changeAnimation("IDLE")

func _on_interectable_input_event(viewport, event, shape_idx):
	super(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		if player and machineUI.result_slot.item:
			if event.is_action_pressed("ACTION2"):
				pickup_sfx.play()
				machineUI.result_slot.item.amount +=machineUI.result_slot.amount
				machineUI.result_slot.item = null
				machineUI.result_slot.amount = 0
