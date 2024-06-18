extends State

@export var escapeTime:Timer

const DECELERATION_FACTOR = 0.9

var directionChangeInterval = 1.0
var timeSinceLastChange = 0.0
var targetDirection = Vector2(0, 0)

func enter() -> void:
	super()
	timeSinceLastChange = 0.0
	escapeTime.start()

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass
	

func physics_update(delta: float) -> void:
	timeSinceLastChange += delta
	if timeSinceLastChange >= directionChangeInterval:
		timeSinceLastChange = 0.0
		targetDirection = moveComponent.getRandomDirection()

	parent.currentDirection = parent.currentDirection.lerp(targetDirection, 0.05)
	parent.velocity = 100 * parent.currentDirection
	parent.move_and_slide()

func process_input(event)->void:
	pass



func _on_escape_time_timeout():
	transitioned.emit("idle")
