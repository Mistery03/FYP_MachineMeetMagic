extends State

@export var chaseSpeed:float
const LEAP_DISTANCE = 45

func enter() -> void:
	super()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)
	print(distance_to_player)
	if distance_to_player <= 14:
		transitioned.emit("death")
	else:
		parent.currentDirection = direction_to_player
		parent.velocity = chaseSpeed * parent.currentDirection * delta
		parent.move_and_slide()
		
func process_input(event)->void:
	pass

