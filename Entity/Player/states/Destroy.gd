extends State

##@NOTE to keep track of wire states
@export_category("Data Tracking")
@export
var wiring_machine_state:State
@export
var wiring_battery_state:State

@export_category("Build Menu")
@export	
var destroyHUD:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}

@export var materialInstance:PackedScene

var cameraSpeed:float = 0
var prevMouseTilePos = Vector2i(-1,-1)
var isOccupied:bool


func enter() -> void:
	super()
	destroyHUD.visible = true
	parent.itemHUDPlaceholder.visible = false

func update(delta: float) -> void:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos) 
	if machineData:
		isOccupied = machineData.get_custom_data("occupied")
		if isOccupied:
			parent.homeTilemap.set_cell(1,mouseTilePos,0,parent.homeTilemap.get_cell_atlas_coords(2,mouseTilePos))
			parent.homeTilemap.set_layer_modulate(1,Color.RED)
			
			var machineList = parent.localLevel.machineList.get_children()
			for machine in machineList:
					if machine.position == parent.homeTilemap.map_to_local(mouseTilePos) and !(machine is Battery):
						machine.animation.stop()
			if Input.is_action_just_pressed("ACTION"):
				parent.breaking_sfx.play()
				for machine in machineList:
					if machine.position == parent.homeTilemap.map_to_local(mouseTilePos):
						if machine is PowerGenerator:
							machine.wireList.clear()
							dropItemsFromFuelSlot(machine)
						elif machine is Battery:
							machine.wireList.clear()
						elif !machine is PowerGenerator:
							dropItemsFromFuelSlot(machine)
							dropItemsFromMaterialSlot(machine)
						
						machine.queue_free()
							
				parent.homeTilemap.erase_cell(2,mouseTilePos)
				parent.homeTilemap.erase_cell(1,mouseTilePos)
				wiring_machine_state.prevGenPos = Vector2i(-100,-100)
				wiring_battery_state.prevBattPos = Vector2i(-100,-100)
				parent.homeTilemap.clear_layer(wiring_machine_state.wireLayer)
				parent.homeTilemap.clear_layer(wiring_battery_state.wireLayer)
				
	wiring_machine_state.updateWithinWireList()
	if mouseTilePos != prevMouseTilePos:
		parent.homeTilemap.erase_cell(1,prevMouseTilePos)
	prevMouseTilePos = mouseTilePos

func physics_update(delta: float) -> void:
	camera.position = moveComponent.get_movement_direction() * parent.moveSpeed * delta

func process_input(event)->void:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()) or Input.is_action_just_pressed("DELETE"):
		destroyHUD.visible = false
		transitioned.emit("build")

func dropItemsFromFuelSlot(machine):
	if machine.machineUI.fuel_slot.item:
		randomize() 
		for i in range(machine.machineUI.fuel_slot.amount):
			var itemDropped = materialInstance.instantiate()
			itemDropped.itemData = machine.machineUI.fuel_slot.item
			itemDropped.amount = 1
			##This is why randomize() is used so it can spawn in different positions relative to the player
			itemDropped.global_position = machine.global_position + Vector2(randi_range(-5,5),20)
			##So it spawns in the level and not the player or anywhere
			parent.localLevel.add_child(itemDropped)
			
func dropItemsFromMaterialSlot(machine):
	if machine.machineUI.material_slot.item:
		randomize() 
		for i in range(machine.machineUI.material_slot.amount):
			var itemDropped = materialInstance.instantiate()
			itemDropped.itemData = machine.machineUI.material_slot.item
			itemDropped.amount = 1
			##This is why randomize() is used so it can spawn in different positions relative to the player
			itemDropped.global_position = machine.global_position + Vector2(randi_range(-5,5),20)
			##So it spawns in the level and not the player or anywhere
			parent.localLevel.add_child(itemDropped)



