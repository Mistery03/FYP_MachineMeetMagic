class_name Room
extends Node2D

@export_category("Room Settings")
@export var PK_roomID:int = 128
@export var roomID:int
@export var roomNum:int = 0
@export_category("Player")
@export var player:Player
@export var fadeOut:TextureRect
@export var door:Node2D

@export var tile_map:TileMap
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
