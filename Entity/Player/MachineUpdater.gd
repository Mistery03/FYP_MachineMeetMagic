"""@NOTE Dear future programmers, the machine updater is to update the batteries and machine process relationship
	The machine updater is used by the WiringBattery state
"""
extends Node
@export var manaOutputPerSecond:int
var batteryList:Array
var machineList:Array

var accumulativeBatteryMaxCapacity:float = 0
var accumulativeBatteryCurrMana:float = 0

var accumulativeMachineMaxCapacity:float = 0
var accumulativeMachineCurrMana:float = 0
func _process(delta):
	pass
	#updateAccumulateMachineMaxCapacity()
	#updateAccumulativeMachineCurrMana()
	#accumulateBatteryMaxCapacity()
	#updateAccumulativeBatteryCurrMana()
	"""for battery in batteryList:
		for machine in machineList:
			if battery.percentage > 0 :
				if is_instance_valid(machine):
					machine.isThereFuel = true
					machine.currMana += manaOutputPerSecond * delta
				#if machine.machineUI.power_switch.button_pressed:
					#battery.consumeMana(machine.manaConsumptionPerSecond,delta)	
				#elif machine.percentage < 100:
					#battery.consumeMana(machine.manaConsumptionPerSecond,delta)
			else:
				if machine != null:
					machine.isThereFuel = false	"""
				
func setMachineUpdaterData(batteryList:Array,machineList:Array):
	self.batteryList = batteryList
	self.machineList = machineList

func updateAccumulateMachineMaxCapacity():
	accumulativeMachineMaxCapacity = 0
	if machineList.size() > 0:
		for machine in machineList:
			accumulativeMachineMaxCapacity += machine.maxMana
		
	print("The current max mana of machine inside Battery network: ",accumulativeMachineMaxCapacity)	
		
func updateAccumulativeMachineCurrMana():
	accumulativeMachineCurrMana = 0.0  # Reset the accumulative current mana
	if machineList.size() > 0:
		for machine in machineList:
			accumulativeMachineCurrMana += machine.currMana
	
	print("The current mana of machine inside Battery network: ",accumulativeBatteryCurrMana)	

func accumulateBatteryMaxCapacity():
	accumulativeBatteryMaxCapacity = 0
	if batteryList.size() > 0:
		for battery in batteryList:
			accumulativeBatteryMaxCapacity += battery.maxCapacity
		
	print(accumulativeBatteryMaxCapacity)

func updateAccumulativeBatteryCurrMana():
	accumulativeBatteryCurrMana = 0.0  # Reset the accumulative current mana
	if batteryList.size() > 0:
		for battery in batteryList:
			accumulativeBatteryCurrMana += battery.currMana

	print("Accumulative Current Mana: ", accumulativeBatteryCurrMana)
