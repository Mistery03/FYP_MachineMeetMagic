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
	print("build mode")

	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(inputList.find_key("Exit").to_upper()) or Input.is_action_just_pressed(inputList.find_key("Build").to_upper()):
		return idle_state
	if Input.is_action_pressed("MOVERIGHT"):
		cameraSpeed = 1

	return null

func process_physics(delta: float) -> State:
	camera.position = move_component.get_movement_direction() * move_speed * delta
	
	var mouseTilePos = parent.homeTilemap.local_to_map(parent.mousePos)
	print(mouseTilePos )
	if Input.is_action_just_pressed("ACTION"):
		parent.homeTilemap.erase_cell(2,mouseTilePos )
	
	return null
