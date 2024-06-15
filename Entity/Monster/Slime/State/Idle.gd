extends State


func enter() -> void:
	super()
	

func exit() -> void:
	pass

func update(delta: float) -> void:
	randomize()
	await get_tree().create_timer(randi_range(2, 5)).timeout
	transitioned.emit("Wander")

func physics_update(delta: float) -> void:
	parent.move_and_slide()



