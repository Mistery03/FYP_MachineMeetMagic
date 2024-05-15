extends Node

var batteryList:Array
var machineList:Array
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for battery in batteryList:
		for machine in machineList:
			if battery.percentage > 0:
				machine.isThereFuel = true
				if machine.machineUI.power_switch.button_pressed:
					battery.consumeMana(machine.manaConsumptionPerSecond,delta)	
			else:
				machine.isThereFuel = false	
				
func setMachineUpdaterData(batteryList:Array,machineList:Array):
	self.batteryList = batteryList
	self.machineList = machineList
