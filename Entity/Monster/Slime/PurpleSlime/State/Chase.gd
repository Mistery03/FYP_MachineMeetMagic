extends State

@export var chaseSpeed:float
@export var separationWeight: float = 3  # Adjust the influence of separation
const SHOOT_DISTANCE = 500


func enter() -> void:
	super()
	parent.set_collision_mask_value(1,true)
	parent.collision_box.set_collision_mask_value(1,true)
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)
	
	var separationForce = _separation(parent)
	print(separationForce)
	parent.currentDirection = (direction_to_player + separationWeight * separationForce).normalized()
	parent.velocity = chaseSpeed * parent.currentDirection * delta
	parent.move_and_slide()
	
	if distance_to_player <= SHOOT_DISTANCE:
		parent.velocity = Vector2.ZERO
		#transitioned.emit("shoot")
		
		
func _separation(slime):
	var sumRepel = Vector2.ZERO
	var count = 0

	for slimeNeighbour in get_tree().get_nodes_in_group("Separable"):
		if slime != slimeNeighbour:  
			sumRepel += _computeRepel(slime,slimeNeighbour)
			count += 1
	if count > 0:
		sumRepel /= count
	return sumRepel

func _computeRepel(slime,slimeNeighbour):

	var repelVeleocity = slime.global_position - slimeNeighbour.global_position
	var dist = repelVeleocity.length()
	var weight = 1.0/(dist*dist+1.0)
	var repelDirection = repelVeleocity.normalized()
	return weight * repelDirection

func _on_collision_box_area_entered(area):
	if area is staffMelee:
		transitioned.emit("damaged")

