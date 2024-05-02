extends Node2D

@onready var player = $Player
@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	player.isBuildEnabled = true
	player.homeTilemap = tile_map



