class_name ExtractorUI
extends Control

@onready var machine_animation = $MachineAnimation



func changeAnimation(animationName:String):
	machine_animation.play(animationName.to_pascal_case())
