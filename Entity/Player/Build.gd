extends State

@export
var move_state: State
@export
var idle_state: State

@export
var buildMenu:Control

@export
var inputList:Dictionary= {
	"Exit":"",
	"Build":""
}

var cameraSpeed:float = 0



func enter() -> void:
	super()
	buildMenu.visible = true
	print("build mode")

	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		buildMenu.visible = false
		return idle_state
	if Input.is_action_pressed("MOVERIGHT"):
		cameraSpeed = 1

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	if Input.is_action_just_pressed("ACTION") and !buildMenu.isInMenu:
		parent.homeTilemap.set_cell(1,mouseTilePos,0,buildMenu.atlasCoord)
	
	return null
