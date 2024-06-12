class_name Build
extends State

##@NOTE to keep track of wire states
@export_category("Data Tracking")
@export
var wiring_machine_state:State
@export
var wiring_battery_state:State

@export_category("Build Menu")
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
var machineInstance:PackedScene


func enter() -> void:
	super()
	buildUI.visible = true
	parent.isBuildMode = true
	parent.itemHUDPlaceholder.visible = false
	camera.position_smoothing_enabled = true
	parent.isPressable = false

func exit() -> void:
	camera.position_smoothing_enabled = false

func update(delta: float) -> void:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)

	var isFloor:TileData = parent.homeTilemap.get_cell_tile_data(0,mouseTilePos) 
	#Now this one actually give u data about machine lmao
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos)
	
	if isFloor:
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
				parent.place_sfx.play()
				set_tile_in_tilemap(mouseTilePos, buildMenu)
				buildMenu.description_board.visible = false
				var instance = machineInstance.instantiate()
				instance.position = parent.homeTilemap.map_to_local(mouseTilePos)
				parent.localLevel.machineList.add_child(instance)
			
			wiring_machine_state.updateWithinWireList()
			wiring_battery_state.updateWithinWireList()
				
func physics_update(delta: float) -> void:
	camera.position = moveComponent.get_movement_direction() * parent.moveSpeed * delta
	
func process_input(event)->void:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		buildUI.visible = false
		buildMenu.atlasCoord = Vector2i(-1,-1)
		parent.homeTilemap.erase_cell(1,prevMouseTilePos)
		parent.isBuildMode = false
		transitioned.emit("idle")
	
	if Input.is_action_just_pressed("DELETE"):
		buildUI.visible = false
		transitioned.emit("destroy")
	
	if Input.is_action_just_pressed("WIRING"):
		buildUI.visible = false
		transitioned.emit("wiringMachine")

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
