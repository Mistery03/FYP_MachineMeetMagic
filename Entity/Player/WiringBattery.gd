class_name WiringBattery
extends State

@export
var build_state: State
@export
var buildUI:Control
@export
var buildMenu:Control
@export
var wiring_machine:State



@export	
var HUD:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}


var cameraSpeed:float = 0
var prevMouseTilePos = Vector2i(-1,-1)
var prevBattPos = Vector2i(-100,-100)
var isOccupied:bool = false
var isFloor:bool
var isCreating:bool = false

var wireTiles:Array = []
var withinWire:Array = []

var wireLayer:int = 8
var machineLayer:int = 2

var batteryList = []


func enter() -> void:
	super()
	enterBuildMode()
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		exitBuildMode()
		return build_state
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) and isCreating:
		isCreating = false
	if Input.is_action_just_pressed("NUMKEY1"):
		return wiring_machine
	
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
	
	handleMachineInteraction(mouseTilePos)
	
	if machineData:
		handleBattery(machineData, wireData, mouseTilePos)
		
	handleWireCreation(mouseTilePos, wireData)
	print(wireTiles)
		
	handleWireRemoval()

	parent.homeTilemap.set_cells_terrain_connect(wireLayer,wireTiles,0,0)	
	
	updateWithinWireList()
	
	
	return null
func enterBuildMode():
	parent.homeTilemap.set_layer_modulate(wireLayer,Color8(0,255,0,255))
	parent.isBuildMode = true
	HUD.visible = true
	HUD.text = "BATTERY WIRING MODE"
	
func exitBuildMode():
	HUD.visible = false
	parent.homeTilemap.set_layer_modulate(wireLayer, Color8(0, 255,0, 0))
	parent.homeTilemap.erase_cell(7, prevBattPos)

func handleMachineInteraction(mouseTilePos):
	parent.homeTilemap.set_cell(7, prevBattPos, 0, Vector2i(5, 5))
	for machine in parent.localLevel.machineList.get_children():
		if machine.position == parent.homeTilemap.map_to_local(mouseTilePos):
			if machine is Battery:
				if Input.is_action_just_pressed("ACTION"):
					parent.homeTilemap.clear_layer(wireLayer)
					parent.homeTilemap.erase_cell(7, prevBattPos)
					parent.homeTilemap.set_cell(7, mouseTilePos, 0, Vector2i(5, 5))
					prevBattPos = mouseTilePos
					wireTiles = machine.wireList
					withinWire = machine.withinWireList
					print(machine.name)
					
func handleBattery(machineData, wireData, mouseTilePos):
	var isBattery = machineData.get_custom_data("Battery")
	isOccupied = wireData and wireData.get_custom_data("occupied") or false

	if Input.is_action_pressed("ACTION") and isBattery and not isOccupied:
		isCreating = true
		

		
func handleWireCreation(mouseTilePos, wireData):
	if wireTiles.size() <=0:
		if isCreating and !isOccupied:	
				if prevMouseTilePos != mouseTilePos:
					wireTiles.append(mouseTilePos)
				prevMouseTilePos = mouseTilePos
	else:
		for pos in wireTiles:
			for validPos in parent.homeTilemap.get_surrounding_cells(pos):
				if isCreating and Input.is_action_pressed("ACTION") and mouseTilePos == validPos and !wireData and validPos != prevBattPos:		
					if prevMouseTilePos != mouseTilePos:
						wireTiles.append(mouseTilePos)
					prevMouseTilePos = mouseTilePos
					
func handleWireRemoval():
	if Input.is_action_just_pressed("ACTION2"):
		if wireTiles.size() == 1:
			wireTiles.clear()
			parent.homeTilemap.clear_layer(wireLayer)
		if not wireTiles.size() <= 0:
			var pos = wireTiles.pop_back()
			parent.homeTilemap.erase_cell(wireLayer, pos)
			parent.homeTilemap.clear_layer(wireLayer)
		else:
			isCreating = false
		prevMouseTilePos = Vector2i(-1, -1)



func updateWithinWireList():
	var machineList = parent.localLevel.machineList.get_children()
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	withinWire.clear()
	batteryList.clear()
	for machine in machineList:
		for pos in wireTiles:
			if parent.homeTilemap.local_to_map(machine.position) == pos and !(machine is Battery):
				withinWire.append(machine)
			if parent.homeTilemap.local_to_map(machine.position) == pos and machine is Battery:
				batteryList.append(machine)
				
	
		
				
	print(batteryList)
	#print(withinWire)
	
	#print(withinWire)
