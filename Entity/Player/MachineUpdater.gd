"""@NOTE Dear future programmers, the machine updater is to update the batteries and machine process relationship
	The machine updater is used by the WiringBattery state
"""
extends Node

var batteryList:Array
var machineList:Array

var accumulativeBatteryMaxCapacity:float = 0
var accumulativeCurrMana:float = 0

func _process(delta):
	for battery in batteryList:
		for machine in machineList:
			if battery.percentage > 0 :
				machine.isThereFuel = true
				#if machine.machineUI.power_switch.button_pressed:
					#battery.consumeMana(machine.manaConsumptionPerSecond,delta)	
				#elif machine.percentage < 100:
					#battery.consumeMana(machine.manaConsumptionPerSecond,delta)
			else:
				if machine != null:
					machine.isThereFuel = false	
				
func setMachineUpdaterData(batteryList:Array,machineList:Array):
	self.batteryList = batteryList
	self.machineList = machineList

func accumulateBatteryMaxCapacity():
	accumulativeBatteryMaxCapacity = 0
	if batteryList.size() > 0:
		for battery in batteryList:
			accumulativeBatteryMaxCapacity += battery.maxCapacity
		
			
	
	print(accumulativeBatteryMaxCapacity)

func updateAccumulativeCurrMana():
	accumulativeCurrMana = 0.0  # Reset the accumulative current mana
	if batteryList.size() > 0:
		for battery in batteryList:
			accumulativeCurrMana += battery.currMana

	print("Accumulative Current Mana: ", accumulativeCurrMana)
