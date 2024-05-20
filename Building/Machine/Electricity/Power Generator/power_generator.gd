class_name PowerGenerator
extends Machine

@export var machineUI:Control
@export var manaPerSecond:float
@export var burnPerSecond:float

@onready var animation = $Animation

var isManaProduced:bool
var machineList:Array = []
var wireList:Array = []
var withinWireList:Array = []

var currManaProduced:float




# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("NoPower")
	await get_tree().create_timer(0.1).timeout
	machineUI.player = player



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isThereFuel:
		if machineUI.power_switch.button_pressed:
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
		burnDisplay(delta)
	
	for machine in self.withinWireList:
		if is_instance_valid(machine):
			machine.isThereFuel = isManaProduced
		if isManaProduced:
			if machine is Battery:
				machine.currMana += manaPerSecond * delta
		
func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and !player.isBuildMode:
		if event.is_action_pressed("ACTION"):
			machineUI.visible = true
			player.itemHUDPlaceholder.visible = false
			player.isMachineUI = true
		

func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false
			player.itemHUDPlaceholder.visible = true
			player.isPressable = false
			player.isMachineUI = false
		

func changeAnimation(animationName:String):
	animation.play(animationName.to_pascal_case())
	machineUI.machine_animation.play(animationName.to_pascal_case())
	
func burnDisplay(delta):
	machineUI.currValue -= burnPerSecond * delta
	machineUI.currValue = clamp(machineUI.currValue, 0, machineUI.maxValue)
	


