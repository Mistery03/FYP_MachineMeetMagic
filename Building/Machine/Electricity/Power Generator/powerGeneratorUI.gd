class_name PowerGeneratorUI
extends Control

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var status_bar = $StatusBar
@onready var fuel_burning = $FuelBurning

@export var maxValue:float = 100
var currValue:float = 100

func _ready():
	fuel_burning.value = currValue
	fuel_burning.max_value = maxValue



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fuel_burning.value = currValue


func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())
