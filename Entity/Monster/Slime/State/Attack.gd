extends State

const LEAP_DISTANCE = 20
const LEAP_SPEED = 8000
const NORMAL_SPEED = 100

var currentDirection = Vector2(1, 0)  # Initial direction
var isLeaping = false

func enter() -> void:
	super()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:

	parent.velocity = LEAP_SPEED * parent.leap_direction  * delta
	
	var distance_to_player = parent.global_position.is_equal_approx(parent.player.global_position)
	
		
		
	parent.move_and_slide()			
			
		
	


func process_input(event)->void:
	pass




