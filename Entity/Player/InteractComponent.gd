class_name IInteractComponent
extends Node

@export var parent:Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent:
		var parentPos = parent.homeTilemap.local_to_map(parent.position)
		var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
		var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos)
	
			
			
