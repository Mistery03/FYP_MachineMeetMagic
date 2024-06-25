extends State

@export var projectile_scene: PackedScene
@export var shoot_interval: float = 1.0  # Time between shots
const SHOOT_DISTANCE = 80

var time_since_last_shot: float = 0.0

func enter() -> void:
	super()
	time_since_last_shot = 0.0

func exit() -> void:
	pass

func update(delta: float) -> void:
	time_since_last_shot += delta

	if time_since_last_shot >= shoot_interval:
		time_since_last_shot = 0.0
		shoot_projectile()

	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)
	if distance_to_player > SHOOT_DISTANCE:
		transitioned.emit("chase")  # Transition back to chase if the player is too far
	
	parent.velocity = Vector2.ZERO
	parent.move_and_slide()

func shoot_projectile():
	var projectile = projectile_scene.instantiate()
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	projectile.direction = direction_to_player
	projectile.global_position = parent.global_position  # Set the initial position of the projectile
	parent.localLevel.add_child(projectile)

func _on_collision_box_area_entered(area):
	if area is staffMelee:
		transitioned.emit("damaged")

