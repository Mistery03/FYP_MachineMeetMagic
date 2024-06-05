class_name Room
extends Node2D

@export_category("Room Settings")
@export var roomName = ""
@export var PK_roomID:int = 128
@export var roomID:int
@export var roomNum:int = 0
@export_category("Player")
@export var player:Player
@export var fadeOut:TextureRect
@export var door:Node2D

@export var tile_map:TileMap

@export_category("Trees")
@export var treeSelection:Array[Vector2i] = [Vector2i(0,0),Vector2i(3,0)]	

var forest = FastNoiseLite.new()
var grassData:TileData
var prevMouseTilePos = Vector2i(-1000,-1000)

func _ready():
	var grassTiles = tile_map.get_used_cells(1)
	for coords in grassTiles:
		grassData = tile_map.get_cell_tile_data(1,coords)
		var canPlace = grassData.get_custom_data("canGenerateCollectibles")
		if canPlace:
			spawnforest(coords.x,coords.y)					

func spawnforest(x, y):
	randomize()
	forest.noise_type = FastNoiseLite.TYPE_PERLIN
	forest.seed = randi() 
	forest.frequency = 0.0005  # Lower frequency for larger patches
	
	var noiseValue = forest.get_noise_2d(x, y)* 15
	var density = randf_range(0, 2)  # Lower density range for less frequent spawns
	if noiseValue > 0.3 and noiseValue < density:  # Adjusted threshold for more controlled spawning
		var random_tree = treeSelection[randi_range(0, treeSelection.size() - 1)]
		tile_map.set_cell(4, Vector2(x, y), 2, random_tree, 0)
		
func setPlayer(player:Player):
	self.player = player

func spawnObjects():
	pass
	
func spawnEnemies():
	pass

func spawnBoss():
	pass

func placePlayer():
	var used_cells = tile_map.get_used_cells(3)
	if used_cells.size() == 0:
		print("No cells used in the specified layer")
		return
	
	var min_x = used_cells[0].x
	var max_x = used_cells[0].x
	var min_y = used_cells[0].y
	var max_y = used_cells[0].y
	
	# Calculate the bounding box of the used cells
	for cell in used_cells:
		if cell.x < min_x:
			min_x = cell.x
		if cell.x > max_x:
			max_x = cell.x
		if cell.y < min_y:
			min_y = cell.y
		if cell.y > max_y:
			max_y = cell.y
	
	# Calculate the center of the bounding box
	var center_x = (min_x + max_x) / 2
	var center_y = (min_y + max_y) / 2
	var center_cell = Vector2(center_x, center_y)
	
	# Convert the center cell to world coordinates
	var world_position = tile_map.map_to_local(center_cell)
	
	if player:
		player.position = world_position
		print("Player placed at: ", player.position)
