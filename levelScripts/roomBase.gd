class_name Room
extends Node2D

@export_category("Level")
@export var levelName:String 

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
@export var treeFrequency:float = 0.0005

@export_category("Stones")
@export var rockSelection:Array[Vector2i]
@export var stoneFrequency:float = 0.0005

@export_category("Creatre Manager")
@export var creatureManager:CreatureManager
@export var creatureList:Array[MobData]
@export var maxCreatureSpawn:int

var objectPosList:Array[Vector2i] = []

var _forest = FastNoiseLite.new()
var _stone = FastNoiseLite.new()
var grassData:TileData
var prevMouseTilePos = Vector2i(-1000,-1000)

var validSpawnPositions = []


func _ready():
	player.localLevel = self
	levelName = roomName
	var grassTiles = tile_map.get_used_cells(1)
	for coords in grassTiles:
		grassData = tile_map.get_cell_tile_data(1,coords)
		var canPlace = grassData.get_custom_data("canGenerateCollectibles")
		if canPlace and roomName != "BossRoom":
			spawnForest(coords.x,coords.y)	
			spawnStone(coords.x,coords.y)				

func spawnForest(x, y):
	randomize()
	_forest.noise_type = FastNoiseLite.TYPE_PERLIN
	_forest.seed = randi() 
	_forest.frequency = treeFrequency  # Lower frequency for larger patches
	
	var noiseValue = _forest.get_noise_2d(x, y)* 12
	var density = randf_range(0, 2)  # Lower density range for less frequent spawns
	if noiseValue > 0.3 and noiseValue < density:  # Adjusted threshold for more controlled spawning
		var random_tree = treeSelection[randi_range(0, treeSelection.size() - 1)]
		tile_map.set_cell(4, Vector2(x, y), 2, random_tree, 0)
		objectPosList.append(Vector2i(x, y))

func spawnStone(x, y):
	randomize()
	_stone.noise_type = FastNoiseLite.TYPE_PERLIN
	_stone.seed = randi() 
	_stone.frequency = stoneFrequency  # Lower frequency for larger patches
	
	var noiseValue = _stone.get_noise_2d(x, y)* 10
	var density = randf_range(0, 2)  # Lower density range for less frequent spawns
	if noiseValue > 0.3 and noiseValue < density:  # Adjusted threshold for more controlled spawning
		var random_stone = rockSelection[randi_range(0, rockSelection.size() - 1)]
		tile_map.set_cell(4, Vector2(x, y), 2, random_stone, 0)
		objectPosList.append(Vector2i(x, y))
		
func setPlayer(player:Player):
	self.player = player

func spawnObjects():
	pass

func spawnCreatures():
	var grassGridPosList = tile_map.get_used_cells(1)
	for pos in grassGridPosList:
		var grassData = tile_map.get_cell_tile_data(1,pos)
		##Reusing the canGenerateCollectibles cause lazy
		var validSpawn = grassData.get_custom_data("canGenerateCollectibles")
		if validSpawn:
			validSpawnPositions.append(pos)
		
	for i in range(maxCreatureSpawn):
		if validSpawnPositions.size() == 0:
			break # No more valid positions to spawn creatures
		
		# Pick a random valid position
		var randomIndex = randi() % validSpawnPositions.size()
		var spawnPos = validSpawnPositions[randomIndex]

		# Remove the chosen position from the list to avoid spawning multiple creatures at the same position
		validSpawnPositions.remove_at(randomIndex)
		
		##NOTE Creature list returns MobData
		var creatureData= creatureList.pick_random()
		var creatureInstance = creatureData.mobInstance.instantiate()
		creatureInstance.global_position = tile_map.map_to_local(spawnPos)
		creatureInstance.localLevel = self
		creatureManager.add_child(creatureInstance)
		creatureManager.init(player)
		creatureInstance.animation.play("SPAWN")

		await get_tree().create_timer(0.2).timeout

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
