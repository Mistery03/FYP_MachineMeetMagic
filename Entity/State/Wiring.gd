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
var prevGenPos = Vector2i(-100,-100)
var isOccupied:bool = false
var isFloor:bool
var isCreating:bool = false

var wireTiles:Array = []
var withinWire:Array = []

var wireLayer:int = 4
var machineLayer:int = 2

var powerGenPosList = []


func enter() -> void:
	super()
	parent.homeTilemap.set_layer_modulate(4,Color8(255,255,255,255))
	parent.isBuildMode = true
	HUD.visible = true
	
	


	
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		HUD.visible = false
		parent.homeTilemap.set_layer_modulate(4,Color8(255,255,255,0))
		parent.homeTilemap.erase_cell(7,prevGenPos)
		return build_state
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) and isCreating:
		isCreating = false
	

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
	
	var machineList = parent.localLevel.machineList.get_children()
	
	parent.homeTilemap.set_cell(7,prevGenPos,0,Vector2i(5,5))
	for machine in machineList:
		if machine.position == parent.homeTilemap.map_to_local(mouseTilePos):
			if machine is PowerGenerator:
				if Input.is_action_just_pressed("ACTION"):
					parent.homeTilemap.clear_layer(wireLayer)
					parent.homeTilemap.erase_cell(7,prevGenPos)
					parent.homeTilemap.set_cell(7,mouseTilePos,0,Vector2i(5,5))
					prevGenPos = mouseTilePos
					wireTiles = machine.wireList
					withinWire = machine.withinWireList
					print(machine.name)
	
	if machineData:
		var isManaGenerator = machineData.get_custom_data("ManaGenerator")
		if wireData :
			isOccupied = wireData.get_custom_data("occupied")
			
	
		else:
			if Input.is_action_pressed("ACTION") and isManaGenerator:
				isCreating = true
				isOccupied = false
		
		
	if wireTiles.size() <=0:
		if isCreating and !isOccupied:	
				if prevMouseTilePos != mouseTilePos:
					wireTiles.append(mouseTilePos)
				prevMouseTilePos = mouseTilePos
	else:
		for pos in wireTiles:
			for validPos in parent.homeTilemap.get_surrounding_cells(pos):
				if isCreating and Input.is_action_pressed("ACTION") and mouseTilePos == validPos and !wireData and validPos != prevGenPos:		
					if prevMouseTilePos != mouseTilePos:
						wireTiles.append(mouseTilePos)
					prevMouseTilePos = mouseTilePos
		
	#Remove Wire	
	if Input.is_action_just_pressed("ACTION2"):
		if !wireTiles.is_empty():
			var pos = wireTiles.pop_back()
			parent.homeTilemap.erase_cell(wireLayer,pos)
			parent.homeTilemap.clear_layer(wireLayer)
		else:
			isCreating = false

		prevMouseTilePos = Vector2i(-1,-1)

	parent.homeTilemap.set_cells_terrain_connect(wireLayer,wireTiles,0,0)	
	
	updateWithinWireList()
	
	
	return null

func updateWithinWireList():
	var machineList = parent.localLevel.machineList.get_children()
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	withinWire.clear()
	for machine in machineList:
		for pos in wireTiles:
			if parent.homeTilemap.local_to_map(machine.position) == pos and !(machine is PowerGenerator):
				withinWire.append(machine)

	#print(withinWire)
	
	#print(withinWire)
