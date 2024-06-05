extends Room

@export var materialInstance:PackedScene 
@export var max_drop_items: int = 5 
@export var colourAdjustment:Color
const HIGHLIGHT_SHADER = preload("res://Shaders/highlightShader.material")
var forest = FastNoiseLite.new()
var fixedSeed: int = randi()
var treeSelection:Array[Vector2i] = [Vector2i(0,0),Vector2i(3,0)]	
var grassData:TileData
var isClicked:bool = false
var is_interacting:bool = false 
var is_holding = false
var hold_time = 0.0
var required_hold_time = 2.0
var materialShader:ShaderMaterial
var prevMouseTilePos = Vector2i(-1000,-1000)


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
		if materialDroppedData:
			tile_map.set_cell(5,mouseTilePos,2,tile_map.get_cell_atlas_coords(4,mouseTilePos))
			tile_map.set_layer_modulate(5,Color.SKY_BLUE)
		if mouseTilePos != prevMouseTilePos:
			tile_map.erase_cell(5,prevMouseTilePos)
		prevMouseTilePos = mouseTilePos
		
		for validPos in validLocation:
			if parentPos == validPos:
				if Input.is_action_pressed("ACTION") and player.isStaffEquipped and !is_interacting:
					player.staff.global_position = player.mousePos
					if materialDroppedData:
						player.staff.customAnimation.play("CUTTING")
						is_interacting = true
						#player.staff.customAnimation.stop()
						await player.staff.customAnimation.animation_finished
						tile_map.erase_cell(5,prevMouseTilePos)
						dropMaterials(materialDroppedData,mouseTilePos)
						is_interacting = false
						player.staff.customAnimation.play("idleFront")
					
			
					
		
				
		
					

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
