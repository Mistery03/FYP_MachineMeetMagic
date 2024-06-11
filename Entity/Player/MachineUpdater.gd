"""@NOTE Dear future programmers, the machine updater is to update the batteries and machine process relationship
	The machine updater is used by the WiringBattery state
"""
extends Node

var batteryList:Array
var machineList:Array

func _process(delta):
	for battery in batteryList:
		for machine in machineList:
			if battery.percentage > 0 :
				machine.isThereFuel = true
				if machine.machineUI.power_switch.button_pressed:
					battery.consumeMana(machine.manaConsumptionPerSecond,delta)	
				#elif machine.percentage < 100:
					#battery.consumeMana(machine.manaConsumptionPerSecond,delta)
			else:
				if machine != null:
					machine.isThereFuel = false	
				
func setMachineUpdaterData(batteryList:Array,machineList:Array):
	self.batteryList = batteryList
	self.machineList = machineList
