class_name WiringMachine
extends State

@export_category("Wiring Menu Setting")
@export
var HUD:Control

@export_category("Input Setting")
@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}


var prevMouseTilePos = Vector2i(-1,-1)
var prevGenPos = Vector2i(-100,-100)

var isOccupied:bool = false
var isFloor:bool
var isCreating:bool = false

var wireTiles:Array = []
var withinWire:Array = []

var wireLayer:int = 4
var machineLayer:int = 2

var accumulativeMachineMaxCapacity = 0
var accumulativeCurrMana:float = 0
var isCalculationsDone:bool


func enter() -> void:
	super()
	enterBuildMode()
	#updateAccumulativeCurrMana()
	parent.itemHUDPlaceholder.visible = false

func update(delta: float) -> void:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)

	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(machineLayer,mouseTilePos)
	var wireData:TileData = parent.homeTilemap.get_cell_tile_data(wireLayer,mouseTilePos)

	var machineList = parent.localLevel.machineList.get_children()

	handleMachineInteraction(mouseTilePos)

	if machineData:
		handleManaGenerator(machineData, wireData, mouseTilePos)

	handleWireCreation(mouseTilePos, wireData)

	handleWireRemoval()

	parent.homeTilemap.set_cells_terrain_connect(wireLayer,wireTiles,0,0)

	#updateAccumulativeCurrMana()

	updateWithinWireList()

func physics_update(delta: float) -> void:
	camera.position = moveComponent.get_movement_direction() * parent.moveSpeed * delta
	camera.position_smoothing_enabled = true

func process_input(event)->void:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		hideWiresOrbuildMode()
		transitioned.emit("build")
	#if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) and isCreating:
		#isCreating = false
	if Input.is_action_just_pressed("NUMKEY2"):
		hideWiresOrbuildMode()
		transitioned.emit("wiringBattery")

func enterBuildMode():
	parent.homeTilemap.set_layer_modulate(wireLayer,Color8(255,255,255,255))
	parent.isBuildMode = true
	HUD.visible = true
	HUD.text = "MACHINE WIRING MODE"

func hideWiresOrbuildMode():
	HUD.visible = false
	parent.homeTilemap.set_layer_modulate(wireLayer, Color8(255, 255, 255, 0))
	parent.homeTilemap.erase_cell(7, prevGenPos)

func handleMachineInteraction(mouseTilePos):
	parent.homeTilemap.set_cell(7, prevGenPos, 0, Vector2i(5, 5))
	for machine in parent.localLevel.machineList.get_children():
		if machine.position == parent.homeTilemap.map_to_local(mouseTilePos):
			if machine is PowerGenerator:
				if Input.is_action_just_pressed("ACTION"):
					parent.homeTilemap.clear_layer(wireLayer)

					##NOTE Show the select indicator
					parent.homeTilemap.erase_cell(7, prevGenPos)
					parent.homeTilemap.set_cell(7, mouseTilePos, 0, Vector2i(5, 5))

					prevGenPos = mouseTilePos
					wireTiles = machine.wireList
					withinWire = machine.withinWireList

					#print(machine.name)

func handleManaGenerator(machineData, wireData, mouseTilePos):
	var isManaGenerator = machineData.get_custom_data("ManaGenerator")
	isOccupied = wireData and wireData.get_custom_data("occupied") or false

	if Input.is_action_pressed("ACTION") and isManaGenerator and not isOccupied:
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

				if isCreating and Input.is_action_pressed("ACTION") and mouseTilePos == validPos and !wireData and validPos != prevGenPos:
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
	for machine in machineList:
		for pos in wireTiles:
			if parent.homeTilemap.local_to_map(machine.position) == pos and !(machine is PowerGenerator):
				addMachine(machine)

	#print(withinWire)

	#print(withinWire)

func addMachine(machine):
	if machine not in withinWire:
		withinWire.append(machine)
		isCalculationsDone = false
		#accumulateMachineMaxCapacity()

func removeBattery(machine):
	if machine in withinWire:
		withinWire.erase(machine)
		isCalculationsDone = false
		#accumulateMachineMaxCapacity()

