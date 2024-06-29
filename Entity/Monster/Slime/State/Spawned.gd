extends State

func enter() -> void:
	super()
	await get_tree().create_timer(5).timeout
	transitioned.emit("Chase")

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass


