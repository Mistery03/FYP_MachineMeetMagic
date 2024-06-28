extends State

@export var chaseSpeed:float
@export var damagePoint:float = 20

func enter() -> void:
	super()
	await get_tree().create_timer(5).timeout
	transitioned.emit("idle")

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)

	parent.currentDirection = direction_to_player
	parent.velocity = chaseSpeed * parent.currentDirection * delta
	parent.move_and_slide()
	
	



func _on_collision_box_body_entered(body):
	if body is Player:
		body.OnDamageTaken.emit(damagePoint)
		transitioned.emit("idle")
