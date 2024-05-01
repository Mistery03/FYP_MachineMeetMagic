extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State

func process_input(event: InputEvent) -> State:
	
	return null

func process_physics(delta: float) -> State:	
	"""if !move_component.get_movement_direction():
		return idle_state
		
	parent.velocity.x = move_component.get_movement_direction().x * move_speed * delta
	parent.sprite.flip_h = move_component.axis.x < 0
	parent.velocity.x =  clamp(parent.velocity.x,-move_speed,move_speed)
	parent.move_and_slide()"""
	

	return null
