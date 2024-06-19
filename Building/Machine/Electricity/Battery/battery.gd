class_name Battery
extends Machine

const MIN_MANA_THRESHOLD: float = 0.0001

@export var maxCapacity:float 
@export var manaOutputPerSecond:int

@onready var sprite = $Sprite

var prevMana:float
var isIncreasing:bool
var batteryBar:int = 0
var maxBatteryBar:int = 4 #this is dependent on frames
var lastPercentage: float

var batteryList:Array = []
var wireList:Array = []
var withinWireList:Array = []

var accumulativeBatteryMaxCapacity:float = 0
var accumulativeBatteryCurrMana:float = 0

var accumulativeMachineMaxCapacity:float = 0
var accumulativeMachineCurrMana:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	updateAccumulateMachineMaxMana()
	updateAccumulativeMachineCurrMana()
	
	currMana = clamp(currMana,0,maxCapacity)
	machineUI.currValue = currMana
	percentage = currMana/maxCapacity *100

	# Check if currMana is increasing or decreasing
	if currMana > prevMana:
		isIncreasing = true
	elif currMana < prevMana:
		isIncreasing = false

	# Update prevCurrMana to the current value of currMana
	prevMana = currMana
	
	if int(fmod(percentage,25)) == 0 and int(percentage) != 0 and int(percentage) != int(lastPercentage) and isIncreasing:
			batteryBar += 1
			batteryBar = clamp(batteryBar,0,4)
			lastPercentage = percentage
	elif int(fmod(percentage,25)) == 0 and int(percentage) != 0 and int(percentage) != int(lastPercentage) and !isIncreasing:
		batteryBar -= 1
		batteryBar = clamp(batteryBar,0,4)
		lastPercentage = percentage
	if percentage == 0:
		batteryBar = 0
			
	changeSpriteFrame(batteryBar)
	
	for machine in withinWireList:
		if is_instance_valid(machine):
			if percentage > 0:
				machine.isThereFuel = true
				machine.currMana += manaOutputPerSecond * delta
				machine.fillManaCapacity(machine.manaConsumptionPerSecond,delta)
				if accumulativeMachineCurrMana < accumulativeMachineMaxCapacity:
					consumeMana(machine.manaConsumptionPerSecond,delta)	
	

func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and !player.isBuildMode:
		if event.is_action_pressed("ACTION"):
			machineUI.visible = true
			player.itemHUDPlaceholder.visible = false
			player.playerHUD.visible = false
			player.isMachineUI = true

func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false
			player.itemHUDPlaceholder.visible = true
			player.playerHUD.visible = true
			player.isPressable = false
			player.isMachineUI = false
			
			
func changeSpriteFrame(frame:int):
	sprite.frame = frame
	machineUI.sprite.frame = frame

#To be used in process function
func consumeMana(manaConsumptionPerSecond:float, delta:float): 
	currMana -= manaConsumptionPerSecond * delta
	if percentage <= MIN_MANA_THRESHOLD:
		currMana = 0

func updateAccumulateMachineMaxMana():
	accumulativeMachineMaxCapacity = 0
	if withinWireList.size() > 0:
		for machine in withinWireList:
			accumulativeMachineMaxCapacity += machine.maxMana
		
	print("The current max mana of machine inside Battery network: ",accumulativeMachineMaxCapacity)	
		
func updateAccumulativeMachineCurrMana():
	accumulativeMachineCurrMana = 0.0  # Reset the accumulative current mana
	if withinWireList.size() > 0:
		for machine in withinWireList:
			accumulativeMachineCurrMana += machine.currMana
	
	print("The current mana of machine inside Battery network: ",accumulativeMachineCurrMana)	

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
