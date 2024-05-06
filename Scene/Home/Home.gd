extends Node2D

@onready var player = $Player
@onready var tile_map = $TileMap
@onready var machineList = $MachineList

# Called when the node enters the scene tree for the first time.
func _ready():
	player.isBuildEnabled = true
	player.homeTilemap = tile_map
	player.localLevel = self
	
func _process(delta) -> void:
	if machineList.get_child_count() <= 0:
		return
	
	#for child in machineList.get_children():
		#print(child.position)

