extends Control
@export var player:Player
@export var potionInventory:Control
@onready var potion_grid_container_player = $PotionGridContainerPlayer
@onready var potion_inventory = $PotionInventory
@onready var inventory_grid = $InventoryGrid

var isDragging

func _ready():
	potion_grid_container_player.player = player
	potion_inventory.player = player
	inventory_grid.init(player)

func _unhandled_input(event):
	if Input.is_action_just_pressed("EXIT") and player.isPressable:
		inventory_grid.update_slots()
