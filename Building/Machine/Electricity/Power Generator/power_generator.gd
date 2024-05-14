class_name PowerGenerator
extends Machine

@export var machineUI:Control
@export var manaPerSecond:float

@onready var animation = $Animation

var isManaProduced:bool
var machineList:Array = []
var wireList:Array = []
var withinWireList:Array = []

var currManaProduced:float




# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("NoPower")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isThereFuel:
		if machineUI.power_switch.button_pressed:
			changeAnimation("Processing")
			machineUI.status_bar.tint_progress = Color.GREEN
			self.isManaProduced = true
		else:
			changeAnimation("idle")
			machineUI.status_bar.tint_progress = Color.YELLOW
			self.isManaProduced = false
	else:
		changeAnimation("NoPower")
		machineUI.status_bar.tint_progress = Color.RED
		self.isManaProduced = false
	
	
	for machine in self.withinWireList:
		if isManaProduced:
			if is_instance_valid(machine):
				machine.isThereFuel = self.isManaProduced
			if machine is Battery:
				machine.currMana += manaPerSecond * delta
		
func _on_interectable_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and !player.isBuildMode:
		if event.is_action_pressed("ACTION"):
			machineUI.visible = true

func _input(event):
	if machineUI.visible:
		if Input.is_action_just_pressed("EXIT"):
			machineUI.visible = false

func changeAnimation(animationName:String):
	animation.play(animationName.to_pascal_case())
	machineUI.machine_animation.play(animationName.to_pascal_case())
