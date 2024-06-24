extends State

var directionChangeInterval = 1.0  # Change direction every second
var timeSinceLastChange = 0.0
var targetDirection  = Vector2(0, 0)  # Initial target direction

var minDistance = 100  # Minimum distance from the spawn point
var maxDistance = 200  # Maximum distance from the spawn point\

func enter() -> void:
	super()

func exit() -> void:
	targetDirection = moveComponent.getRandomDirection() # Reset target direction
	parent.currentDirection = targetDirection  # Set current direction to new target

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	targetDirection = (parent.spawnPoint - parent.global_position).normalized()
	parent.velocity = parent.moveSpeed * targetDirection
	parent.move_and_slide()

	# Check if the object has returned to the spawn point
	if parent.global_position.distance_to(parent.spawnPoint) < minDistance:
		await  get_tree().create_timer(2).timeout
		transitioned.emit("Idle")
		


