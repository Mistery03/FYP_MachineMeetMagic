class_name Wiring
extends State

@export
var build_state: State

@export
var buildUI:Control
@export
var buildMenu:Control

@export	
var HUD:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}


var cameraSpeed:float = 0
var prevMouseTilePos = Vector2i(-1,-1)
var isOccupied:bool
var isFloor:bool

var wireTiles:Array = []
var withinWire:Array = []

var wireLayer:int = 4
var machineLayer:int = 2


func enter() -> void:
	super()
	parent.homeTilemap.set_layer_modulate(4,Color8(255,255,255,255))
	parent.isBuildMode = true
	HUD.visible = true
	


	
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		HUD.visible = false
		parent.homeTilemap.set_layer_modulate(4,Color8(255,255,255,0))
		return build_state
	

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	camera.position_smoothing_enabled = true
	
	return null
	
func process_frame(delta:float) -> State:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(machineLayer,mouseTilePos) 
	var wireData:TileData = parent.homeTilemap.get_cell_tile_data(wireLayer,mouseTilePos)	
	

	
	if Input.is_action_pressed("ACTION"):
		if prevMouseTilePos != mouseTilePos:
			wireTiles.append(mouseTilePos)
		prevMouseTilePos = mouseTilePos
		
		
	#Remove Wire	
	if Input.is_action_pressed("ACTION2"):
		parent.homeTilemap.erase_cell(4,mouseTilePos)
		for pos in wireTiles:
			if pos == mouseTilePos:
				var index = wireTiles.find(pos)
				wireTiles.remove_at(index)
				parent.homeTilemap.clear_layer(wireLayer)

	parent.homeTilemap.set_cells_terrain_connect(wireLayer,wireTiles,0,0)	
	
	var machineList = parent.localLevel.machineList.get_children()
	withinWire.clear()
	
	for machine in machineList:
		for pos in wireTiles:
			if wireData :
				if parent.homeTilemap.local_to_map(machine.position) == pos and !isOccupied:
					withinWire.append(machine)
			else:
				if parent.homeTilemap.local_to_map(machine.position) == pos:
					withinWire.append(machine)
	print(withinWire)
	return null


