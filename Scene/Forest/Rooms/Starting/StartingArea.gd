extends Room

var forest = FastNoiseLite.new()
var fixedSeed: int = randi()
var treeSelection:Array[Vector2i] = [Vector2i(0,0),Vector2i(3,0)]	
var grassData:TileData

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
	

