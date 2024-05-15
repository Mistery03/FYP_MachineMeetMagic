extends Control

@export var player:Player

@onready var potion_inventory = $".."

@onready var grid_container = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if potion_inventory:
		for potionSlot in grid_container.get_children():
			potionSlot.potionInventory = potion_inventory
			
