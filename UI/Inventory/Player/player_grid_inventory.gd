extends Control

@export var inventorySlot:PackedScene
@export var maxInventorySlot:int
#@onready var power_generator_ui = $".."

var player:Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if player:
		#maxInventorySlot = player.playerMaxInventorySize
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#initInventorySlot()\
	pass

func initInventorySlot():
	for child in get_children():
		child.queue_free()
		
	for index in range(maxInventorySlot):
		var slot = inventorySlot.instantiate()
		add_child(slot)
		
func showPlayerInventory():
	pass
