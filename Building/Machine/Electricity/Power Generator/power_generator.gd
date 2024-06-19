class_name PowerGenerator
extends Machine

@export var manaPerSecond:float
@export var burnPerSecond:float

var isManaProduced:bool

var wireList:Array = []
var withinWireList:Array = []

var currManaProduced:float

var accumulativePerctange:float = 0
var accumulativeMaxPerctange:float = 0

var accumulativeMachineMaxCapacity = 0
var accumulativeCurrMana:float = 0
var isCalculationsDone:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("NoPower")
	super()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateAccumulateMachineMaxCapacity()
	updateAccumulativeMachineCurrMana()
	
	if isThereFuel:
		if machineUI.power_switch.button_pressed:
			if withinWireList.size() >0:
				changeAnimation("Processing")
				machineUI.status_bar.tint_progress = Color.GREEN
				isSwitchedOn = true
				isManaProduced = true
						
		else:
			changeAnimation("idle")
			machineUI.status_bar.tint_progress = Color.YELLOW
			isSwitchedOn = false
			isManaProduced = false
	else:
		changeAnimation("NoPower")
		machineUI.status_bar.tint_progress = Color.RED
		isSwitchedOn = false
		isManaProduced = false
	
	if isSwitchedOn:
		if accumulativeCurrMana < accumulativeMachineMaxCapacity:
			machineUI.burnDisplay(delta)
		else:
			changeAnimation("idle")
			machineUI.status_bar.tint_progress = Color.YELLOW
	
	for machine in withinWireList:
		if is_instance_valid(machine):
			machine.isThereFuel = isManaProduced
		if isManaProduced:
			machine.currMana += machineUI.fuel_slot.item.manaProducedPerSecond * delta
			if !machine is Battery:
				machine.fillManaCapacity(machineUI.fuel_slot.item.manaProducedPerSecond,delta)
		


func updateAccumulateMachineMaxCapacity():
	accumulativeMachineMaxCapacity = 0
	if withinWireList.size() > 0:
		for machine in withinWireList:
			accumulativeMachineMaxCapacity += machine.maxMana
		
		isCalculationsDone = true
	#print("INSIDE powergen ",accumulativeMachineMaxCapacity)	
		
func updateAccumulativeMachineCurrMana():
	accumulativeCurrMana = 0.0  # Reset the accumulative current mana
	if withinWireList.size() > 0:
		for machine in withinWireList:
			accumulativeCurrMana += machine.currMana

	#print("Accumulative Current Mana: ", accumulativeCurrMana)

