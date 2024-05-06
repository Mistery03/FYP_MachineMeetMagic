extends State


@export
var build_state: State

@export
var buildUI:Control

@export
var buildMenu:Control

@export	
var destroyHUD:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}

var cameraSpeed:float = 0
var prevMouseTilePos = Vector2i(-1,-1)
var isOccupied:bool


func enter() -> void:
	super()
	buildUI.visible = false
	destroyHUD.visible = true


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()) or Input.is_action_just_pressed("DELETE"):
		destroyHUD.visible = false
		return build_state
	

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	
	
	return null
	
func process_frame(delta:float) -> State:
	var parentPos = parent.homeTilemap.local_to_map(parent.position)
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	var machineData:TileData = parent.homeTilemap.get_cell_tile_data(2,mouseTilePos) 
	if machineData:
		isOccupied = machineData.get_custom_data("occupied")
		if isOccupied:
			parent.homeTilemap.set_cell(1,mouseTilePos,0,parent.homeTilemap.get_cell_atlas_coords(2,mouseTilePos))
			parent.homeTilemap.set_layer_modulate(1,Color.RED)
			
			var machineList = parent.localLevel.machineList.get_children()
			
			if Input.is_action_just_pressed("ACTION"):
				for machine in machineList:
					if machine.position == parent.homeTilemap.map_to_local(mouseTilePos):
						machine.queue_free()
				parent.homeTilemap.erase_cell(2,mouseTilePos)
				parent.homeTilemap.erase_cell(1,mouseTilePos)
	
	if mouseTilePos != prevMouseTilePos:
		parent.homeTilemap.erase_cell(1,prevMouseTilePos)
	prevMouseTilePos = mouseTilePos

	
	return null




