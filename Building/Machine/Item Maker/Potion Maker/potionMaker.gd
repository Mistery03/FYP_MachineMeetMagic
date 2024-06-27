class_name PotionMaker
extends Machine

@export var originalTexture:Texture2D
@onready var potion_sprite = $PotionSprite



func _ready():
	potion_sprite.texture = originalTexture
	changeAnimation("IDLE")
	machineUI.machine_mana_bar.max_value = maxMana
	super()
	
func _process(delta):
	currMana = clamp(currMana,0,maxMana)
	percentage = currMana/maxMana *100
	
	if isThereFuel:
		machineUI.power_switch.disabled = false	
		changeAnimation("Standby")
		#fillManaCapacity(delta)
	else:
		if currMana <= 0:
			machineUI.power_switch.disabled = true
			changeAnimation("NoPower")
	
	if machineUI.power_switch.button_pressed:
		isSwitchedOn = true
	else:
		changeAnimation("Standby")
		isSwitchedOn = false

func _on_interectable_input_event(viewport, event, shape_idx):
	super(viewport, event, shape_idx)
	if event is InputEventMouseButton:
		if player and machineUI.result_slot.item:
			if event.is_action_pressed("ACTION2"):
				pickup_sfx.play()
				machineUI.result_slot.item.amount +=machineUI.result_slot.amount
				potion_sprite.texture = originalTexture
				machineUI.result_slot.item = null
				machineUI.result_slot.amount = 0
