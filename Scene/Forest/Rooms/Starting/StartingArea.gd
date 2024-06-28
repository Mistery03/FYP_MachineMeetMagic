extends Room


@export var colourAdjustment:Color

func _ready():
	super()

	tile_map.set_layer_modulate(7,Color8(255, 255, 255, 0));
	var teleporterGridCoords = tile_map.get_used_cells(7)
	var teleporterData = tile_map.get_cell_tile_data(7,teleporterGridCoords[0])
	var instanceToSpawn = teleporterData.get_custom_data("Teleporter")
	var instance = instanceToSpawn.instantiate()
	instance.position = tile_map.map_to_local(teleporterGridCoords[0])
	add_child(instance)
	
	spawnCreatures()






