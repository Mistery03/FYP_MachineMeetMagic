extends Control

@export var player:Player

@export var potion_inventory:Control
@onready var grid_container = $GridContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if potion_inventory:
		for potionSlot in grid_container.get_children():
			potionSlot.potionInventory = potion_inventory



