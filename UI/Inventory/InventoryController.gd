extends Control
@export var player:Player
@export var potionInventory:Control
@onready var potion_grid_container_player = $PotionGridContainerPlayer
@onready var potion_inventory = $PotionInventory
@onready var inventory_grid = $InventoryGrid


func _ready():
	potion_grid_container_player.player = player
	potion_inventory.player = player
	inventory_grid.init(player)
	
'func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("EXIT"):
			potionInventory.visible = false'
			

