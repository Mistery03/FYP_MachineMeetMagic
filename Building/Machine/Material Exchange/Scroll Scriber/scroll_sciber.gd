class_name ScrollSciber
extends Machine

# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("IDLE")
	super()
	
func _on_interectable_input_event(viewport, event, shape_idx):
	super(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		if player and machineUI.result_slot.item:
			if event.is_action_pressed("ACTION2"):
				pickup_sfx.play()
				player.ResearchPointCurrency +=machineUI.result_slot.amount
				machineUI.result_slot.item = null
				machineUI.result_slot.amount = 0
	
