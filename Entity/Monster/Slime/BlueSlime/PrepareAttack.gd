extends State


func enter() -> void:
	super()
	parent.velocity = Vector2.ZERO
	parent.originalPos = parent.global_position
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	await get_tree().create_timer(2).timeout
	parent.leap_direction = (parent.player.global_position - parent.global_position).normalized()
	transitioned.emit("attack")

func physics_update(delta: float) -> void:
	pass

func process_input(event)->void:
	pass

