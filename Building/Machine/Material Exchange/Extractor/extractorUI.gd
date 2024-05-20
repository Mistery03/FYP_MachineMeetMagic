class_name ExtractorUI
extends Control

@onready var machine_animation = $MachineAnimation
@onready var power_switch = $PowerSwitch
@onready var machine_mana_bar = $MachineManaBar
@export var parentMachine:Machine

var currValue:float = 100
var player:Player

var isDragging:bool = false
var gridMousePos:Vector2i
var slotMousPos:Vector2i

func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())
