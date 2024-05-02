extends State


@export
var idle_state: State


func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:	
	if !move_component.get_movement_direction():
		return idle_state

	parent.velocity.x = move_component.get_movement_direction().x * move_speed * delta
	parent.velocity.y = move_component.get_movement_direction().y * move_speed * delta
	parent.animation.flip_h = move_component.axis.x < 0
	if parent.velocity.y < 0:
		animations.play(animationList.find_key("WalkBackward").to_upper())
	elif parent.velocity.y > 0:
		animations.play(animationList.find_key("WalkFront").to_upper())
	else:
		animations.play(animation_name.to_upper())
	#parent.velocity.x =  clamp(parent.velocity.x,-move_speed,move_speed)
	parent.move_and_slide()
	

	return null
