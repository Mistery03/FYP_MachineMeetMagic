extends State

const LEAP_SPEED = 12000
var direction
var bounce_direction 
var distance_to_target 

func enter() -> void:
	super()
	bounce_direction = (parent.originalPos - parent.global_position).normalized()
	parent.hasCollidedWithPlayer = true
	

func exit() -> void:
	parent.hasCollidedWithPlayer = false

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	parent.velocity = LEAP_SPEED * bounce_direction  * delta # Bounce back at half speed
	distance_to_target = parent.global_position.distance_to(parent.originalPos)

	if int(distance_to_target) <= 1:
		parent.velocity = Vector2.ZERO
		transitioned.emit("chase")
	#parent.velocity = LEAP_SPEED * 0.5 * -direction * delta
	parent.move_and_slide()

	
	#parent.move_and_slide()

func process_input(event)->void:
	pass

