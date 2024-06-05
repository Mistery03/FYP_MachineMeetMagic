extends State

@export
var idle_state: State

func enter() -> void:
	super()
	parent.itemHUDPlaceholder.visible = true

func process_input(event: InputEvent) -> State:


	if Input.is_action_just_pressed("EXIT"):
		toggle_menu()
	return null

func process_physics(delta: float) -> State:
	var movement_direction = move_component.get_movement_direction()	
	
	if !movement_direction:
		#resetStaffPosition()
		return idle_state

	updatePlayerVelocity(delta,movement_direction)
	#parent.velocity.x =  clamp(parent.velocity.x,-move_speed,move_speed)
	parent.move_and_slide()
	

	return null

func resetStaffPosition():
	parent.staff.z_index = -1
	#parent.staff.rotation = 1.5708
	#parent.staff.position = parent.staff.originalPos
	#parent.staff.animation.flip_v = false

func updatePlayerVelocity(delta, movement_direction):
	parent.velocity = movement_direction * move_speed * delta
	parent.animation.flip_h = movement_direction.x < 0
	
	changeAnimationVelocity()
	
	if parent.staff:
		if !parent.isStaffEquipped:
			#parent.staff.animation.flip_v = movement_direction.y < 0
			updateStaffPosX()
			updateStaffPosY()
		else:
			if parent.velocity.y >0:
				parent.staff.customAnimation.play("idleFront")
			if parent.velocity.y < 0:
				parent.staff.customAnimation.play("idleBack")
			if parent.velocity.x <0:
				parent.staff.customAnimation.play("idleBack")
			if parent.velocity.x > 0:
				parent.staff.customAnimation.play("idleFront")

		
func changeAnimationVelocity():
	if parent.velocity.y < 0:
		animations.play(animationList.find_key("WalkBackward").to_upper())
	elif parent.velocity.y >0:
		animations.play(animationList.find_key("WalkFront").to_upper())
	else:
		animations.play(animation_name.to_upper())

func updateStaffPosX():
	#parent.staff.z_index = -1
	if parent.velocity.x < 0:
		parent.staff.customAnimation.play("RESETRIGHT")
		#parent.staff.position = Vector2(50, -20) 
	elif parent.velocity.x > 0:
		parent.staff.customAnimation.play("RESETLEFT")
		#parent.staff.position = Vector2(-50, -20)


func updateStaffPosY():
	
	if parent.velocity.y < 0:
		parent.staff.customAnimation.play("RESETBACK")
	elif parent.velocity.y >0:
		parent.staff.customAnimation.play("RESETFRONT")
		


	
func staffPosWhenXandY(zIndex:int): #when both action both x and y are pressed
	parent.staff.z_index = zIndex
	#parent.staff.rotation = 1.5708
	#parent.staff.position = parent.staff.originalPos
	
func toggle_menu():
	# Toggle the visibility of the menu
	parent.playerInventoryController.visible = !parent.playerInventoryController.visible 
