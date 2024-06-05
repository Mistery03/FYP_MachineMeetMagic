extends Room

@export var materialInstance:PackedScene 
@export var max_drop_items: int = 5  

var forest = FastNoiseLite.new()
var fixedSeed: int = randi()
var treeSelection:Array[Vector2i] = [Vector2i(0,0),Vector2i(3,0)]	
var grassData:TileData
var isClicked:bool = false
var is_interacting:bool = false 


func _ready():
	var grassTiles = tile_map.get_used_cells(1)
	for coords in grassTiles:
		grassData = tile_map.get_cell_tile_data(1,coords)
		var canPlace = grassData.get_custom_data("canGenerateCollectibles")
		if canPlace:
			spawnforest(coords.x,coords.y)
	
func _process(delta):
	if player:
		var mouseTilePos = tile_map.local_to_map(player.mousePos)
		var parentPos = tile_map.local_to_map(player.position)
		var materialDroppedData = tile_map.get_cell_tile_data(4,mouseTilePos)
		var validLocation = tile_map.get_surrounding_cells(mouseTilePos)
		for validPos in validLocation:
			if parentPos == validPos:
				if Input.is_action_just_pressed("ACTION") and player.isStaffEquipped and !is_interacting:
					
					#player.staff.customAnimation.queue("CUTTING")
					player.staff.global_position = player.mousePos
					if materialDroppedData:
						is_interacting = true
						#player.staff.customAnimation.stop()
						player.staff.customAnimation.play("CUTTING")
						await player.staff.customAnimation.animation_finished
						dropMaterials(materialDroppedData,mouseTilePos)
						is_interacting = false
					else:
						is_interacting = false
					
					

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
	
func dropMaterials(materialDroppedData,mouseTilePos)->bool:
	var materialRes = materialDroppedData.get_custom_data("materialDropped")
	var num_items_to_drop = randi_range(1, max_drop_items)
	for i in range(num_items_to_drop):
		var instance = materialInstance.instantiate()
		instance.itemData = materialRes
		instance.amount = 1
		instance.position = tile_map.map_to_local(mouseTilePos) + Vector2(randi_range(-5, 5), randi_range(-5, 5))  # Randomize position slightly
		instance.z_index = 10
		add_child(instance)
	tile_map.erase_cell(4,mouseTilePos)
	return true
