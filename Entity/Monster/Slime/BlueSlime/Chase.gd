extends State

@export var chaseSpeed:float
const LEAP_DISTANCE = 45

func enter() -> void:
	super()
	parent.collision_box.set_collision_mask_value(0,true)
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	if parent.currHealth <= 0:
		transitioned.emit("death")

func physics_update(delta: float) -> void:
	var direction_to_player = (parent.player.global_position - parent.global_position).normalized()
	var distance_to_player = parent.global_position.distance_to(parent.player.global_position)
	print(distance_to_player)
	
	parent.currentDirection = direction_to_player
	parent.velocity = chaseSpeed * parent.currentDirection * delta
	parent.move_and_slide()
		
func process_input(event)->void:
	pass


func _on_collision_box_body_entered(body):
	parent.player.OnDamageTaken.emit(parent.damagePoint)
	transitioned.emit("death")
