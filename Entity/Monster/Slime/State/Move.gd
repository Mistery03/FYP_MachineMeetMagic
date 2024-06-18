extends State

const DECELERATION_FACTOR = 0.9 

var directionChangeInterval = 1.0  # Change direction every second
var timeSinceLastChange = 0.0
var targetDirection  = Vector2(0, 0)  # Initial target direction

var minDistance = 100  # Minimum distance from the spawn point
var maxDistance = 200  # Maximum distance from the spawn point\



func enter() -> void:
	super()
	parent.collision_box.set_collision_mask_value(1,false)
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	_wander(delta)
	
	#await  get_tree().create_timer(3).timeout
	
	_smooth_stop(delta)

func _wander(delta):
	parent.position += parent.velocity * delta
	#rotation = maxRotation * randi_range(-1,1)
	timeSinceLastChange += delta
	
	if timeSinceLastChange >= directionChangeInterval:
		timeSinceLastChange = 0
		targetDirection = moveComponent.getRandomDirection()
		
		if randi() % 100 < 5:  
			transitioned.emit("Return")
		
	parent.currentDirection = parent.currentDirection.lerp(targetDirection, 0.05)
	
	# Ensure the object stays within the specified range
	var distanceFromSpawn = parent.global_position.distance_to(parent.spawnPoint)
	if distanceFromSpawn > maxDistance:
		transitioned.emit("Return")
	elif distanceFromSpawn < minDistance:
		# If too close to spawn point, move away from it
		targetDirection = (parent.global_position- parent.spawnPoint).normalized()
	
	parent.velocity = parent.moveSpeed * parent.currentDirection
	parent.move_and_slide()

func _smooth_stop(delta):
	# Gradually reduce the slime's velocity
	parent.velocity *= DECELERATION_FACTOR
	parent.move_and_slide()

	# Transition to idle state when velocity is close to zero
	if parent.velocity.length() < 1.0:
		parent.velocity = Vector2.ZERO
		transitioned.emit("idle")



