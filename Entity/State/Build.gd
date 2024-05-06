extends State

@export
var move_state: State
@export
var idle_state: State
@export 
var delete_state:State

@export
var buildUI:Control
@export
var buildMenu:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}

var cameraSpeed:float = 0
var prevMouseTilePos = Vector2i(-1,-1)
var isOccupied:bool
var isFloor:bool


func enter() -> void:
	super()
	buildUI.visible = true
	
	print("build mode")

	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		buildUI.visible = false
		buildMenu.atlasCoord = Vector2i(-1,-1)
		parent.homeTilemap.erase_cell(1,prevMouseTilePos)
		return idle_state
	
	if Input.is_action_just_pressed("DELETE"):
		buildUI.visible = false
		return delete_state

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	
	
	return null
	
func process_frame(delta:float) -> State:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	
	var floorData:TileData = parent.homeTilemap.get_cell_tile_data(0,mouseTilePos)
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos)
	
	if floorData:
		if machineData:
			isOccupied = machineData.get_custom_data("occupied")
			
			# Set the color based on whether the tile is occupied
			set_tile_color_based_on_occupation(isOccupied, mouseTilePos, parentPos)

			if !isOccupied and Input.is_action_just_pressed("ACTION") and !buildMenu.isInMenu and mouseTilePos != parentPos:
				set_tile_in_tilemap(mouseTilePos, buildMenu)
		else:
			# Default to green if there's no tile data
			set_tile_color_based_on_occupation(false, mouseTilePos, parentPos)

			if Input.is_action_just_pressed("ACTION") and !buildMenu.isInMenu and mouseTilePos != parentPos:
				set_tile_in_tilemap(mouseTilePos, buildMenu)

		parent.homeTilemap.set_cell(1,mouseTilePos,0,buildMenu.atlasCoord)
	
		if mouseTilePos != prevMouseTilePos:
			parent.homeTilemap.erase_cell(1,prevMouseTilePos)
		prevMouseTilePos = mouseTilePos

	
	return null

# Function to check if a tile is occupied and set the layer color accordingly
func set_tile_color_based_on_occupation(is_occupied, mousePos, parentPos):
	if is_occupied or mousePos == parentPos:
		parent.homeTilemap.set_layer_modulate(1, Color.RED)
	else:
		parent.homeTilemap.set_layer_modulate(1, Color.GREEN)

# Function to handle setting a tile in the TileMap
func set_tile_in_tilemap(mouseTilePos, buildMenu):
	parent.homeTilemap.set_cell(2, mouseTilePos, 0, buildMenu.atlasCoord)
	buildMenu.atlasCoord = Vector2i(-1, -1)
	buildUI.visible = true
