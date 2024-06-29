extends State


@export var separationWeight: float = 3  # Adjust the influence of separation
@export var SHOOT_DISTANCE = 240

@export var jump_attack_probability: float = 30.0
@export var spawn_creatures_probability: float = 10.0
@export var dash_attack_probability: float = 60.0


func enter() -> void:
	super()
	parent.set_collision_mask_value(1,true)
	parent.collision_box.set_collision_mask_value(9,true)


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
	parent.velocity = parent.chaseSpeed * parent.currentDirection * delta
	parent.move_and_slide()

	if distance_to_player <= SHOOT_DISTANCE:
		choose_attack()

func choose_attack():
	var random_value = randi() % 100 # Generate a random value between 0 and 99

	if random_value < jump_attack_probability:
		transitioned.emit("JumpAttack")
	elif random_value < jump_attack_probability + spawn_creatures_probability:
		transitioned.emit("SpawnSlimes")
	elif random_value < jump_attack_probability + spawn_creatures_probability + dash_attack_probability:
		transitioned.emit("DashAttack")


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


func _on_boss_slime_on_damage_taken(damageAmount):
	parent.currHealth -= damageAmount
	parent.currHealth = clamp(parent.currHealth,0,parent.maxHP)
	transitioned.emit("damaged")


func _on_collision_box_body_entered(body):
	if body is Slime:
		parent.currHealth += (body.currHealth*0.5)
		parent.currHealth = clamp(parent.currHealth,0,parent.maxHP)
		body.queue_free()
