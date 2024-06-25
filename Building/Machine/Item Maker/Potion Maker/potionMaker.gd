class_name PotionMaker
extends Machine


func _ready():
	changeAnimation("IDLE")
	machineUI.machine_mana_bar.max_value = maxMana
	super()
