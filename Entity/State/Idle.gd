extends State

@export
var move_state: State
@export
var build_state:State

@export
var inputList:Dictionary= {
	"Build":""
}

var lerp_timer: Timer
var isBuildEnabled:bool = true


func enter() -> void:
	super()
	camera.position_smoothing_enabled = false
	
	lerp_to_zero()
	parent.itemHUDPlaceholder.visible = true
	await parent.get_tree().create_timer(0.2).timeout
	parent.isPressable = true
	parent.velocity.x = 0.0
	
	
func lerp_to_zero():
	# Gradually lerp the velocity to 0
	parent.velocity.x = lerp(parent.velocity.x, 0.0, 0.2)
	parent.velocity.y = lerp(parent.velocity.y, 0.0, 0.2)

# Check if the velocity is close enough to 0
	if abs(parent.velocity.x) < 0.01:
		parent.velocity.x = 0.0

func process_input(event: InputEvent) -> State:
	move_component.axis = move_component.get_movement_direction()

	if move_component.axis:
		return move_state
	
	if Input.is_action_just_pressed(inputList.find_key("Build").to_upper()) and isBuildEnabled and !parent.playerInventory.visible:
		parent.isPressable = false
		return build_state
	
	if Input.is_action_just_pressed("EXIT") and parent.isPressable:
		toggle_menu()
	return null

func process_frame(delta: float) -> State:
	isBuildEnabled = parent.isBuildEnabled
	if parent.staff:
		if parent.isStaffEquipped:
			parent.staff.customAnimation.play("idleFront")
		else:
			parent.staff.customAnimation.play("RESET")
	
	return null

func toggle_menu():
	# Toggle the visibility of the menu
	parent.playerInventory.visible = !parent.playerInventory.visible 
