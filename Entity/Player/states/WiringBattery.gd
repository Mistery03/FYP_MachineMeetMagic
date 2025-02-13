class_name WiringBattery
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
var prevBattPos = Vector2i(-100,-100)

var isOccupied:bool = false
var isFloor:bool
var isCreating:bool = false
var isCalculationsDone: bool = false
var isSubtractionCalculationsDone: bool = false

var wireTiles:Array = []
var withinWire:Array = []
var batteryList:Array = []

var wireLayer:int = 8
var machineLayer:int = 2

var accumulativeBatteryMaxCapacity:float = 0
var accumulativeCurrMana:float = 0

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

	#handleMachineInteraction(mouseTilePos)
	if machineData:
		handleBattery(machineData, wireData, mouseTilePos)

	handleWireCreation(mouseTilePos, wireData)


	handleWireRemoval(machineData)

	parent.homeTilemap.set_cells_terrain_connect(wireLayer,wireTiles,0,0)

	#updateAccumulativeCurrMana()
	#machineUpdater.setMachineUpdaterData(batteryList,withinWire)
	updateWithinWireList()

	updateBatteryData()

func physics_update(delta: float) -> void:
	camera.position = moveComponent.get_movement_direction() * parent.moveSpeed * delta
	camera.position_smoothing_enabled = true

func process_input(event)->void:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		hideWiresOrbuildMode()
		transitioned.emit("build")
	#if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) and isCreating:
		#isCreating = false
	if Input.is_action_just_pressed("NUMKEY1"):
		hideWiresOrbuildMode()
		parent.change_sfx.play()
		transitioned.emit("wiringMachine")

func enterBuildMode():
	parent.homeTilemap.set_layer_modulate(wireLayer,Color8(0,255,0,255))
	parent.isBuildMode = true
	HUD.visible = true
	HUD.text = "BATTERY WIRING MODE"

func hideWiresOrbuildMode():
	HUD.visible = false
	parent.homeTilemap.set_layer_modulate(wireLayer, Color8(0, 255,0, 0))
	parent.homeTilemap.erase_cell(7, prevBattPos)

func handleBattery(machineData, wireData, mouseTilePos):
	var isBattery = machineData.get_custom_data("Battery")
	isOccupied = wireData and wireData.get_custom_data("occupied") or false

	if Input.is_action_pressed("ACTION") and isBattery and not isOccupied:
		isCreating = true
		isCalculationsDone = false

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

func handleWireRemoval(machineData):
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
		var machinePos = parent.homeTilemap.local_to_map(machine.position)
		for pos in wireTiles:
			if machinePos == pos:
				if !machine is Battery and !machine is PowerGenerator:
					withinWire.append(machine)
				elif  machine is Battery:
					addBattery(machine)

	#print(batteryList)
	#print(withinWire)

	#print(withinWire)

# Call this function whenever you add a battery to the list
func addBattery(battery):
	if battery not in batteryList:
		batteryList.append(battery)
		isCalculationsDone = false
		#accumulateBatteryMaxCapacity()

# Call this function whenever you remove a battery from the list
func removeBattery(battery):
	if battery in batteryList:
		batteryList.erase(battery)
		isCalculationsDone = false
		#accumulateBatteryMaxCapacity()

func updateBatteryData():
	for machine in parent.localLevel.machineList.get_children():
		if machine is Battery:
			machine.wireList = wireTiles
			machine.withinWireList = withinWire
			machine.batteryList = batteryList


