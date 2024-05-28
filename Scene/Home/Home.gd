extends Node2D


@export_category("Level")
@export var levelName:String = "Home"

@export_category("Player Settings")
@export var player:Player
@export var isBuildEnabled:bool = false

@onready var tile_map = $TileMap
@onready var machineList = $MachineList

# Called when the node enters the scene tree for the first time.
func _ready():
	player.isBuildEnabled = isBuildEnabled
	player.homeTilemap = tile_map
	player.localLevel = self
	machineList.player = player 
	

	

