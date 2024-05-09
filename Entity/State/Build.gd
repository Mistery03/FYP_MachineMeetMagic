class_name Build
extends State

@export
var move_state: State
@export
var idle_state: State
@export 
var delete_state:State
@export
var wiring_state:State

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
var machineInstance:PackedScene


func enter() -> void:
	super()
	buildUI.visible = true
	parent.isBuildMode = true
	

	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		buildUI.visible = false
		buildMenu.atlasCoord = Vector2i(-1,-1)
		parent.homeTilemap.erase_cell(1,prevMouseTilePos)
		parent.isBuildMode = false
		return idle_state
	
	if Input.is_action_just_pressed("DELETE"):
		buildUI.visible = false
		return delete_state
	
	if Input.is_action_just_pressed("WIRING"):
		buildUI.visible = false
		return wiring_state

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	camera.position_smoothing_enabled = true
	
	return null
	
func process_frame(delta:float) -> State:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	
	#named it floorData but really the data is to check if there is floor in the world
	var floorData:TileData = parent.homeTilemap.get_cell_tile_data(0,mouseTilePos) 
	#Now this one actually give u data about machine lmao
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos)
	
	if floorData:
		parent.homeTilemap.set_cell(1,mouseTilePos,0,buildMenu.atlasCoord)
		
		if mouseTilePos != prevMouseTilePos:
			parent.homeTilemap.erase_cell(1,prevMouseTilePos)
		prevMouseTilePos = mouseTilePos
		
		var machinePreviewData:TileData = parent.homeTilemap.get_cell_tile_data(1,mouseTilePos)
		
		if machinePreviewData:
			machineInstance =  machinePreviewData.get_custom_data(buildMenu.buildingName.to_pascal_case())
			
		if machineData:
			isOccupied = machineData.get_custom_data("occupied")
			set_tile_color_based_on_occupation(isOccupied, mouseTilePos, parentPos)

		else:
			#No need to use isOccupied here cause there no machine to be found
			set_tile_color_based_on_occupation(false, mouseTilePos, parentPos)

			if Input.is_action_just_pressed("ACTION") and !buildMenu.isInMenu and mouseTilePos != parentPos and machinePreviewData:
				set_tile_in_tilemap(mouseTilePos, buildMenu)
				buildMenu.description_board.visible = false
				var instance = machineInstance.instantiate()
				instance.position = parent.homeTilemap.map_to_local(mouseTilePos)
				parent.localLevel.machineList.add_child(instance)
				
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
