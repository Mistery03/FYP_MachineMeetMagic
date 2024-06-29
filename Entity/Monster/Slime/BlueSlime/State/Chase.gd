extends State

@export var separationWeight: float = 1.0  # Adjust the influence of separation
const LEAP_DISTANCE = 45

func enter() -> void:
	super()
	parent.set_collision_mask_value(1,false)
	parent.collision_box.set_collision_mask_value(1,true)
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)
	
	parent.currentDirection = direction_to_player
	parent.velocity = parent.chaseSpeed * parent.currentDirection * delta
	parent.move_and_slide()
		

func _on_collision_box_body_entered(body):
	if body is Player:
		parent.player.OnDamageTaken.emit(parent.damagePoint)
		transitioned.emit("death")
		
func apply_separation_force(separation_force: Vector2, weight: float) -> void:
	# Apply separation force to the current direction
	parent.currentDirection += separation_force * weight
	parent.currentDirection = parent.currentDirection.normalized()

func _on_collision_box_area_entered(area):
	if area is staffMelee:
		transitioned.emit("damaged")
