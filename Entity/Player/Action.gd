extends State

@export
var move_state: State
@export
var build_state:State
@export 
var action_state:State

@export
var inputList:Dictionary= {
	"Build":""
}

var lerp_timer: Timer
var isBuildEnabled:bool = true


func enter() -> void:
	super()
	

	
	


func process_input(event: InputEvent) -> State:
	move_component.axis = move_component.get_movement_direction()

	if move_component.axis:
		return move_state
	
	if Input.is_action_pressed("ACTION"):
		parent.staff.customAnimation.stop()
	
	if Input.is_action_just_pressed(inputList.find_key("Build").to_upper()) and isBuildEnabled and !parent.playerInventoryController.visible:
		parent.isPressable = false
		return build_state
	
	
	return null

func process_frame(delta: float) -> State:
	isBuildEnabled = parent.isBuildEnabled
	if parent.staff:
		if parent.isStaffEquipped:
			parent.staff.customAnimation.play("idleFront")
		else:
			parent.staff.customAnimation.play("RESET")
	
	return null


