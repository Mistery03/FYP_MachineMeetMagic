class_name Extractor
extends Machine

@export var machineUI:Control

@onready var animation = $Animation

# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("IDLE")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#for machine in machineList:
		#if is_instance_valid(machine):
			#if machine is PowerGenerator:
				#isThereFuel = machine.isManaProduced
	print(isThereFuel)
	if isThereFuel:
		machineUI.power_switch.button_pressed = true
		if machineUI.power_switch.button_pressed:
			changeAnimation("Processing")
			machineUI.power_switch.button_pressed = true
		else:
			changeAnimation("IDLE")
			machineUI.power_switch.button_pressed = false
	else:
		changeAnimation("IDLE")
		machineUI.power_switch.button_pressed = false


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
