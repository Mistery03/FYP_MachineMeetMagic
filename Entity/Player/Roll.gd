extends State

var roll_speed_multiplier = 6.0

func enter() -> void:
	super()

	moveComponent.rollTimer.start()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	parent.velocity= moveComponent.get_movement_direction() * 9000 * delta
	parent.move_and_slide()

func process_input(event)->void:
	pass

func endDash():
	parent.canDash = false
	await get_tree().create_timer(0.4).timeout
	parent.canDash = true
	parent.set_collision_layer_value(1,true)
	transitioned.emit("move")

func _on_roll_duration_timeout():
	endDash()




