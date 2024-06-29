extends Control

@onready var wiring_label = $WiringLabel

@export var text:String

func _process(delta):
	wiring_label.text = text
