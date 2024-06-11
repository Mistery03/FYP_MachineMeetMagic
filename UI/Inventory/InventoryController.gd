extends Control

@export var potionInventory:Control

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("ACTION2"):
			potionInventory.visible = false
